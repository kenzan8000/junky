#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedSubsUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedSubsUnreadOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"


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
        self.list = @[];
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
    __weak __typeof(self) weakSelf = self;
    // 未読フィード一覧
    JBRSSFeedSubsUnreadOperation *operation = [[JBRSSFeedSubsUnreadOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            JBLog(@"%@", [object JSON]);

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

- (NSInteger)count
{
    return [self.list count];
}

- (JBRSSFeedSubsUnread *)unreadWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
}


@end
