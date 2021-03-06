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
@implementation JBRSSFeedSubsUnreadList


#pragma mark - property
@synthesize delegate;
@synthesize feedCountOfEachRate;


#pragma mark - class meethod
/**
 * 一覧更新処理用のmanagedObjectContext
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)mainContext
{
    static dispatch_once_t onceToken = NULL;
    static NSManagedObjectContext *_JBRSSFeedSubsUnreadListManagedObjectContext = nil;

    dispatch_once(&onceToken, ^ () {
        _JBRSSFeedSubsUnreadListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_JBRSSFeedSubsUnreadListManagedObjectContext setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
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
        [[NLCoreData shared] setModelName:kXCDataModelName];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
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
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

- (void)loadFeedFromLocal
{
    __weak __typeof(self) weakSelf = self;
    NSManagedObjectContext *context = [JBRSSFeedSubsUnreadList managedObjectContextForThread:[NSThread new]];
    [context performBlock: ^ () {
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:
            [JBRSSFeedSubsUnread fetchWithRequest:^ (NSFetchRequest *request) {
                [request setPredicate:nil];
                [request setReturnsObjectsAsFaults:NO];
                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rate"
                                                                             ascending:NO];
                [request setSortDescriptors:@[descriptor]];
            }
                                           context:context]
        ];
        // count fo each rate
        [weakSelf setFeedCountOfEachRateWithSubsUnreadList:temporaryArray];
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFinishLoadWithList:)]) {
                [weakSelf.delegate feedDidFinishLoadWithList:weakSelf];
            }
        });
    }];
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
        if (row - feedCountOfTheRate < 0) { break; }
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
    // create list and save
    NSManagedObjectContext *context = [JBRSSFeedSubsUnreadList managedObjectContextForThread:[NSThread new]];
    [context performBlock: ^ () {
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
        [context save];
    }];
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
