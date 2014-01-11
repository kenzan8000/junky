#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedSubsUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedSubsUnreadOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"
/// Pods
#import "NLCoreData.h"


#pragma mark - JBRSSFeedSubsUnreadList
@interface JBRSSFeedSubsUnreadList ()


/// 一覧の更新処理のためのQueue
@property (nonatomic, assign) dispatch_queue_t updateQueue;


@end


#pragma mark - JBRSSFeedSubsUnreadList
@implementation JBRSSFeedSubsUnreadList


#pragma mark - property
@synthesize delegate;
@synthesize list;
@synthesize feedCountOfEachRate;
@synthesize updateQueue;


#pragma mark - class meethod
/**
 * 一覧更新処理用のmanagedObjectContext
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContext
{
    static dispatch_once_t onceToken = NULL;
    static NSManagedObjectContext *_JBRSSFeedSubsUnreadListManagedObjectContext = nil;

    dispatch_once(&onceToken, ^ () {
        _JBRSSFeedSubsUnreadListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_JBRSSFeedSubsUnreadListManagedObjectContext setParentContext:[NSManagedObjectContext mainContext]];
    });

    return _JBRSSFeedSubsUnreadListManagedObjectContext;
}


#pragma mark - initializer
- (id)initWithDelegate:(id<JBRSSFeedSubsUnreadListDelegate>)del
{
    self = [super init];
    if (self) {
        self.delegate = del;
        self.list = [NSMutableArray arrayWithArray:@[]];
        self.feedCountOfEachRate = @[@(0), @(0), @(0), @(0), @(0), @(0)];

        NSString *queueName = [NSString stringWithFormat:@"%@.%@",
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
            NSStringFromClass([JBRSSFeedSubsUnreadList class])
        ];
        self.updateQueue = dispatch_queue_create([queueName cStringUsingEncoding:[NSString defaultCStringEncoding]], NULL);
        [[NLCoreData shared] setModelName:NSStringFromClass([JBRSSFeedSubsUnread class])];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    dispatch_release(self.updateQueue);
    self.list = nil;
    self.feedCountOfEachRate = nil;
}


#pragma mark - api
- (void)loadFeedFromWebAPI
{
    __weak __typeof(self) weakSelf = self;
    // 未読フィード一覧
    JBRSSFeedSubsUnreadOperation *operation = [[JBRSSFeedSubsUnreadOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);
            [weakSelf finishLoadListWithJSON:JSON];

            return;
        }
        // 失敗
        [weakSelf failLoadListWithError:error];
    }];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

- (void)loadFeedFromLocal
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(weakSelf.updateQueue, ^ () {
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:
            [JBRSSFeedSubsUnread fetchInContext:[JBRSSFeedSubsUnreadList managedObjectContext]
                                      predicate:nil]
        ];
        // sort by rate
        temporaryArray = [weakSelf rateSortedListWithSubsUnreadList:temporaryArray];
        // count fo each rate
        [weakSelf setFeedCountOfEachRateWithSubsUnreadList:temporaryArray];
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFinishLoadWithList:)]) {
                [weakSelf.delegate feedDidFinishLoadWithList:weakSelf];
            }
        });
    });
}

- (NSInteger)count
{
    return [self.list count];
}

- (NSInteger)feedCountWithRate:(NSInteger)rate
{
    if (rate < 0 || rate >= self.feedCountOfEachRate.count) {
        return 0;
    }
    return [self.feedCountOfEachRate[rate] integerValue];
}

- (JBRSSFeedSubsUnread *)unreadWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
}

- (JBRSSFeedSubsUnread *)unreadWithIndexPath:(NSIndexPath *)indexPath
{
    return [self unreadWithIndex:[self indexWithIndexPath:indexPath]];
}

- (NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        offset += [self feedCountWithRate:i];
    }
    return (indexPath.row + offset);
}

- (NSIndexPath *)indexPathWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }

    NSInteger row = index;
    NSInteger section = 0;
    for (NSInteger i = 0; i < self.feedCountOfEachRate.count; i++) {
        NSInteger feedCountOfTheRate = [self feedCountWithRate:i];
        if (row - feedCountOfTheRate) { break; }
        row -= feedCountOfTheRate;
        section++;
    }

    return [NSIndexPath indexPathForRow:row
                              inSection:section];
}


#pragma makr - private api
/**
 * フィードのロード完了後処理
 * @param JSON JSON
 */
- (void)finishLoadListWithJSON:(NSArray *)JSON
{
    if (JSON == nil) { return; }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(weakSelf.updateQueue, ^ () {
        // create list and save
        NSManagedObjectContext *context = [JBRSSFeedSubsUnreadList managedObjectContext];
        [JBRSSFeedSubsUnread deleteInContext:context
                                   predicate:nil];
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:@[]];
        for (NSDictionary *dict in JSON) {
            JBRSSFeedSubsUnread *subsUnread = [JBRSSFeedSubsUnread insertInContext:context];
            subsUnread.subscribeId = [NSString stringWithFormat:@"%@", dict[@"subscribe_id"]];
            subsUnread.title = [NSString stringWithFormat:@"%@", dict[@"title"]];
            subsUnread.unreadCount = @([dict[@"unread_count"] integerValue]);
            subsUnread.rate = @([dict[@"rate"] integerValue]);
            subsUnread.folder = [NSString stringWithFormat:@"%@", dict[@"folder"]];
            subsUnread.feedlink = [NSString stringWithFormat:@"%@", dict[@"feedlink"]];
            subsUnread.link = [NSString stringWithFormat:@"%@", dict[@"link"]];
            subsUnread.icon = [NSString stringWithFormat:@"%@", dict[@"icon"]];

            [temporaryArray addObject:subsUnread];
        }
        [context save];
        // sort by rate
        temporaryArray = [weakSelf rateSortedListWithSubsUnreadList:temporaryArray];
        // count fo each rate
        [weakSelf setFeedCountOfEachRateWithSubsUnreadList:temporaryArray];
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFinishLoadWithList:)]) {
                [weakSelf.delegate feedDidFinishLoadWithList:weakSelf];
            }
        });
    });
}

/**
 * フィードの読み込み失敗処理
 * @param error error
 */
- (void)failLoadListWithError:(NSError *)error
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFailLoadWithError:)]) {
            [weakSelf.delegate feedDidFailLoadWithError:error];
        }
    });
}

/**
 * feedCountOfEachRateをセット
 * @param unreadList JBRSSFeedSubsUnreadのリスト
 */
- (void)setFeedCountOfEachRateWithSubsUnreadList:(NSArray *)unreadList
{
    NSInteger feedCount[] = {0, 0, 0, 0, 0, 0}; // count feed of each rate
    for (JBRSSFeedSubsUnread *subsUnread in unreadList) {
        NSInteger rate = [subsUnread.rate integerValue];
        if (rate < 0 || rate >= [self.feedCountOfEachRate count]) { continue; }
        feedCount[rate]++;
    }

    self.feedCountOfEachRate = @[
        @(feedCount[5]), @(feedCount[4]), @(feedCount[3]), @(feedCount[2]), @(feedCount[1]), @(feedCount[0])
    ];
}

/**
 * レイティングでソート済みのSubsUnreadを返す
 * @param list JBRSSFeedSubsUnreadのリスト
 * @return unreadList
 */
- (NSMutableArray *)rateSortedListWithSubsUnreadList:(NSArray *)unreadList
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rate"
                                                                 ascending:NO];
    NSMutableArray *sortedList = (NSMutableArray *)[unreadList sortedArrayUsingDescriptors:@[descriptor]];
    return sortedList;
}


@end
