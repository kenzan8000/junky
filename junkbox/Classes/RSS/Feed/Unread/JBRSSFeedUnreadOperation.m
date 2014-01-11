#import "JBRSSConstant.h"
#import "JBRSSFeedUnreadOperation.h"
#import "JBRSSOperationQueue.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSFeedUnreadOperation
@implementation JBRSSFeedUnreadOperation


#pragma mark - synthesize
@synthesize subscribeId;


#pragma mark - initializer
- (id)initWithSubscribeId:(NSString *)sId
                  handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // エラー判定
        NSInteger unreadErrorCode = (error) ? error.code : response.statusCode;
        NSError *unreadError = nil;
        if (unreadErrorCode >= http::statusCode::ERROR) {
            unreadError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                     code:unreadErrorCode
                                                 userInfo:@{}];
        }

        h(response, object, unreadError);
    };

    self = [super initWithRequest:[NSMutableURLRequest JBRSSUnreadRequestWithSubscribeId:sId]
                          handler:handler];
    if (self) {
        self.subscribeId = sId;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    if ([self APIURL]) {
        [[JBRSSOperationQueue defaultQueue] cancelOperationsWithURL:[self APIURL]];
    }

    self.subscribeId = nil;
}


#pragma mark - api
- (void)start
{
    // ネットワークに接続できない
    if ([[Reachability reachabilityForInternetConnection] isReachable] == NO) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        self.handler(nil,
                     @{},
                     [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                code:http::NOT_REACHABLE
                                                userInfo:@{}]);
        return;
    }

    [super start];
}

- (NSURL *)APIURL
{
    return [self.request URL];
}


#pragma mark - private api


@end

