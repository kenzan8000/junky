#import "JBRSSOperation.h"
#import "JBRSSOperationQueue.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSOperation
@implementation JBRSSOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithRequest:(NSURLRequest *)request
              handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;
{
    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // エラー判定
        NSInteger eCode = (error) ? error.code : response.statusCode;
        NSError *e = nil;
        if (eCode == http::statusCode::FORBIDDEN) {
            NSString *errorMessage = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
            if ([errorMessage isEqualToString:@"Not Authorized"]) {
                eCode = http::statusCode::UNAUTHORIZED;
            }
        }
        if (eCode >= http::statusCode::ERROR) {
            e = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                           code:eCode
                                       userInfo:@{}];
        }

        h(response, object, e);
    };

    self = [super initWithRequest:request
                          handler:handler];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [[JBRSSOperationQueue defaultQueue] cancelOperationsWithURL:self.request.URL];
}


#pragma mark - api
- (BOOL)isReachable
{
    return [[Reachability reachabilityForInternetConnection] isReachable];
}

- (void)cancelBeforeConnectionIfNotReachable
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    self.handler(nil,
                 @{},
                 [[NSError alloc] initWithDomain:NSMachErrorDomain
                                            code:http::NOT_REACHABLE
                                            userInfo:@{}]);
}


@end

