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
            //[JBRSSFeedSubsUnread fetchWithRequest:^ (NSFetchRequest *request) { [request setReturnsObjectsAsFaults:NO]; }
            //                              context:[JBRSSFeedSubsUnreadList managedObjectContext]]

        ];
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

- (JBRSSFeedSubsUnread *)unreadWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
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
        weakSelf.list = [NSMutableArray arrayWithArray:@[]];
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

            if (context.saveNested) {
                [temporaryArray addObject:subsUnread];
            }
        }

        // sort by rate
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rate"
                                                                     ascending:NO];
        temporaryArray = (NSMutableArray *)[temporaryArray sortedArrayUsingDescriptors:@[descriptor]];

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


@end
