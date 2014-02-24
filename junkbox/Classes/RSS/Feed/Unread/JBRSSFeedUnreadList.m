#import "JBRSSFeedUnreadList.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedUnreadOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedUnreadList
@interface JBRSSFeedUnreadList ()


/// 詳細リストの更新処理のためのQueue
@property (nonatomic, strong) dispatch_queue_t updateQueue;


@end


#pragma mark - JBRSSFeedUnreadList
@implementation JBRSSFeedUnreadList


#pragma mark - property
@synthesize listDelegate;
@synthesize listsDelegate;
@synthesize list;
@synthesize operation;
@synthesize updateQueue;
@synthesize isUnread;


#pragma mark - initializer
- (id)initWithSubscribeId:(NSString *)subscribeId
             listDelegate:(id<JBRSSFeedUnreadListDelegate>)listDel
            listsDelegate:(id<JBRSSFeedUnreadListsDelegate>)listsDel
{
    self = [super init];
    if (self) {
        self.listDelegate = listDel;
        self.listsDelegate = listsDel;
        self.list = [NSMutableArray arrayWithArray:@[]];

        __weak __typeof(self) weakSelf = self;
        // フィード詳細取得
        JBRSSFeedUnreadOperation *op = [[JBRSSFeedUnreadOperation alloc] initWithSubscribeId:subscribeId
                                                                                     handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
            // 成功
            if (error == nil) {
                NSDictionary *JSON = [object JSON];
                JBLog(@"%@", JSON);
                [weakSelf finishLoadListWithJSON:JSON];

                return;
            }
            // 失敗
            [weakSelf failLoadListWithError:error];
        }];
        self.operation = op;

        // 詳細リストの更新処理
        NSString *queueName = [NSString stringWithFormat:@"%@.%@",
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
            NSStringFromClass([JBRSSFeedUnreadList class])
        ];
        self.updateQueue = dispatch_queue_create([queueName cStringUsingEncoding:[NSString defaultCStringEncoding]], NULL);

        self.isUnread = YES;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.updateQueue = nil;
    self.operation = nil;
    self.list = nil;
}


#pragma mark - api
- (void)loadFeedFromWebAPI
{
    [[JBRSSOperationQueue defaultQueue] addOperation:self.operation];
}

- (void)stopLoadingFeedFromWebAPI
{
    NSURL *APIURL = [self.operation APIURL];
    if (APIURL) {
        [[JBRSSOperationQueue defaultQueue] cancelOperationsWithURL:APIURL];
    }
}

- (void)setOperationQueuePriority:(NSOperationQueuePriority)priority
{
    [self.operation setQueuePriority:priority];
}

- (NSInteger)count
{
    return [self.list count];
}

- (JBRSSFeedUnread *)unreadWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
}


#pragma makr - private api
/**
 * ロード完了後処理
 * @param JSON JSON
 */
- (void)finishLoadListWithJSON:(NSDictionary *)JSON
{
    __weak __typeof(self) weakSelf = self;

    dispatch_async(weakSelf.updateQueue, ^ () {
        // JSON操作
        NSMutableArray *temporaryArray = [weakSelf newListWithJSON:JSON];

        // Delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.listsDelegate && [weakSelf.listsDelegate respondsToSelector:@selector(unreadListsDidFinishLoadWithList:)]) {
                [weakSelf.listsDelegate unreadListsDidFinishLoadWithList:weakSelf];
            }
            if (weakSelf.listDelegate && [weakSelf.listDelegate respondsToSelector:@selector(unreadListDidFinishLoadWithList:)]) {
                [weakSelf.listDelegate unreadListDidFinishLoadWithList:weakSelf];
            }
        });
    });
}

/**
 * ロード失敗後処理
 * @param error error
 */
- (void)failLoadListWithError:(NSError *)error
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.listsDelegate && [weakSelf.listsDelegate respondsToSelector:@selector(unreadListsDidFailLoadWithError:list:)]) {
            [weakSelf.listsDelegate unreadListsDidFailLoadWithError:error
                                                               list:weakSelf];
        }
        if (weakSelf.listDelegate && [weakSelf.listDelegate respondsToSelector:@selector(unreadListDidFailLoadWithError:)]) {
            [weakSelf.listDelegate unreadListDidFailLoadWithError:error];
        }
    });
}

/**
 * JSONから詳細のリストへ置き換え
 * @param JSON JSON
 * @return 新しい詳細リスト
 */
- (NSMutableArray *)newListWithJSON:(NSDictionary *)JSON
{
    if (JSON == nil) { return [NSMutableArray arrayWithArray:@[]]; }
    if ([JSON isKindOfClass:[NSDictionary class]] == NO) { return [NSMutableArray arrayWithArray:@[]]; }

    NSArray *items = JSON[@"items"];
    if (items == nil) { return [NSMutableArray arrayWithArray:@[]]; }

    NSMutableArray *newList = [NSMutableArray arrayWithArray:@[]];
    for (NSDictionary *item in items) {
        if ([item isKindOfClass:[NSDictionary class]] == NO) { continue; }
        JBRSSFeedUnread *unread = [JBRSSFeedUnread new];
        unread.title = [NSString stringWithFormat:@"%@", item[@"title"]];
        unread.link = [NSURL URLWithString:[NSString stringWithFormat:@"%@", item[@"link"]]];
        unread.body = [NSString stringWithFormat:@"%@", item[@"body"]];
        [newList addObject:unread];
    }
    return newList;
}

- (BOOL)isFinishedLoading
{
    return ([self count] > 0);
}


@end
