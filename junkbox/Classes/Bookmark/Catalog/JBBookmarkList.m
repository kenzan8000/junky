#import "JBBookmarkList.h"
#import "JBBookmarkCatalogOperation.h"
#import "JBBookmarkOperationQueue.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
/// Pods
#import "NLCoreData.h"
#import "HTBHatenaBookmarkManager.h"


#pragma mark - JBBookmarkList
@implementation JBBookmarkList


#pragma mark - property
@synthesize delegate;


#pragma mark - class meethod
+ (JBBookmarkList *)sharedInstance
{
    static dispatch_once_t onceToken = NULL;
    static JBBookmarkList *_JBBookmarkList = nil;
    dispatch_once(&onceToken, ^ () {
        _JBBookmarkList = [JBBookmarkList new];
    });
    return _JBBookmarkList;
}

/**
 * 一覧更新処理用のmanagedObjectContext
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContext
{
    static dispatch_once_t onceToken = NULL;
    static NSManagedObjectContext *_JBBookmarkListManagedObjectContext = nil;

    dispatch_once(&onceToken, ^ () {
        _JBBookmarkListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_JBBookmarkListManagedObjectContext setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
    });

    return _JBBookmarkListManagedObjectContext;
}


#pragma mark - initializer


#pragma mark - release
- (void)dealloc
{
    self.delegate = nil;
    self.updateQueue = nil;
    self.list = nil;
}


#pragma mark - api
- (void)loadFromWebAPI
{
    // 認証済みでない
    if ([HTBHatenaBookmarkManager sharedManager].authorized == NO) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    // 未読フィード一覧
    JBBookmarkCatalogOperation *operation = [[JBBookmarkCatalogOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
/*
            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);
            [weakSelf finishLoadListWithJSON:JSON];
*/
            return;
        }
        // 失敗
        [weakSelf failLoadListWithError:error];
    }];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBBookmarkOperationQueue defaultQueue] addOperation:operation];
}

- (void)loadFromLocal
{
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
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bookmarkListDidFinishLoadWithList:)]) {
                [weakSelf.delegate bookmarkListDidFinishLoadWithList:weakSelf];
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
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bookmarkListDidFailLoadWithError:)]) {
            [weakSelf.delegate bookmarkListDidFailLoadWithError:error];
        }
    });
}


@end
