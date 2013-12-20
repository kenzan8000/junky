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
/// 未読フィード一覧
@implementation JBRSSFeedSubsUnreadList


#pragma mark - property
@synthesize delegate;
@synthesize list;


#pragma mark - initializer
- (id)initWithDelegate:(id<JBRSSFeedSubsUnreadListDelegate>)del
{
    self = [super init];
    if (self) {
        self.delegate = del;
        self.list = [NSMutableArray arrayWithArray:@[]];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api
- (void)loadFeed
{
//    if () {
//        [self loadFeedFromLocal];
//    }
//    else {
        [self loadFeedFromWebAPI];
//    }
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
 * WebAPIからフィードをロード
 */
- (void)loadFeedFromWebAPI
{
    __weak __typeof(self) weakSelf = self;
    // 未読フィード一覧
    JBRSSFeedSubsUnreadOperation *operation = [[JBRSSFeedSubsUnreadOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);
            [weakSelf createListWithJSON:JSON];

            dispatch_async(dispatch_get_main_queue(), ^ () {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFinishLoadWithList:)]) {
                    [weakSelf.delegate feedDidFinishLoadWithList:weakSelf];
                }
            });
            return;
        }
        // 失敗
        dispatch_async(dispatch_get_main_queue(), ^ () {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(feedDidFailLoadWithError:)]) {
                [weakSelf.delegate feedDidFailLoadWithError:error];
            }
        });
    }];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

/**
 * ローカルに保存されていたフィードをロード
 */
- (void)loadFeedFromLocal
{
}

/**
 * API戻り値のJSONからモデルのリストを生成
 * @param JSON JSON
 */
- (void)createListWithJSON:(NSArray *)JSON
{
    // check JSON
    if (JSON == nil) { return; }
/*
    // create list and save
    self.list = [NSMutableArray arrayWithArray:@[]];
    for (NSDictionary *dict in JSON) {
        NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
        JBRSSFeedSubsUnread *subsUnread = [JBRSSFeedSubsUnread insertInContext:context];
        subsUnread.subscribeId = [NSString stringWithFormat:@"%@", dict[@"subscribe_id"]];
        context.saveNested;
        [self.list addObject:subsUnread];
    }

    // sort by star
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.lifeTime" ascending:YES];
    self.list = (NSMutableArray *)[self.list sortedArrayUsingDescriptors:@[descriptor]];
*/
}


@end
