#import "JBRSSConstant.h"
#import "JBRSSLoginOperation.h"
#import "JBRSSOperationQueue.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSHTTPCookieStorage+Cookie.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSLoginOperation
@implementation JBRSSLoginOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithUsername:(NSString *)u
              password:(NSString *)p
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    // RSS Readerに新しくログインする場合、他のRSS関連の通信をすべて止める
    [[JBRSSOperationQueue defaultQueue] cancelAllOperations];

    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        NSInteger errorCode = error.code;
        // セッションを持っているか
        if (errorCode == http::statusCode::SUCCESS) {
           BOOL hasSession = [[NSHTTPCookieStorage sharedHTTPCookieStorage] hasCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                                        domains:kSessionDomainsLivedoorReaderLogin];
            if (hasSession == NO) { errorCode = http::statusCode::UNAUTHORIZED; }
        }

        // 失敗
        NSError *loginError = error;
        if (errorCode >= http::statusCode::ERROR) {
            loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                    code:errorCode
                                                userInfo:@{}];
        }

        h(response, object, loginError);

        // ログインに失敗した場合、他のRSS関連の通信をすべて止める
        if (loginError) {
            [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
        }
    };

    self = [super initWithUsername:u
                          password:p
                           handler:handler
                           request:[NSMutableURLRequest JBRSSLoginRequestWithLivedoorID:u password:p]];

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

    // セッションクリア
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                 domains:kSessionDomainsLivedoorReaderLogin];

    [super start];
}


#pragma mark - private api


@end

