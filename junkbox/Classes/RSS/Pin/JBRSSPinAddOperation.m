#import "JBRSSConstant.h"
#import "JBRSSPinAddOperation.h"
#import "JBRSSOperationQueue.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSPinAddOperation
@implementation JBRSSPinAddOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
             pinTitle:(NSString *)pinTitle
              pinLink:(NSString *)pinLink
{
    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // エラー判定
        NSInteger subsUnreadErrorCode = (error) ? error.code : response.statusCode;
        NSError *subsUnreadError = nil;
        if (subsUnreadErrorCode >= http::statusCode::ERROR) {
            subsUnreadError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                         code:subsUnreadErrorCode
                                                     userInfo:@{}];
        }

        h(response, object, subsUnreadError);
    };

    self = [super initWithRequest:[NSMutableURLRequest JBRSSAddPinRequestWithTitle:pinTitle
                                                                              link:pinLink]
                          handler:handler];
    if (self) {
    }
    return self;
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


#pragma mark - private api


@end
