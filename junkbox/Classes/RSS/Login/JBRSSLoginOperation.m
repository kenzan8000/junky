#import "JBRSSConstant.h"
#import "JBRSSLoginOperation.h"
#import "JBRSSOperationQueue.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
#import "ISHTTPOperation.h"
/// NSFoundation-Extension
#import "NSHTTPCookieStorage+Cookie.h"
/// Pods
#import "Reachability.h"
#import "MTStatusBarOverlay.h"


#pragma mark - JBRSSLoginOperation
@implementation JBRSSLoginOperation


#pragma mark - synthesize
@synthesize username;
@synthesize password;


#pragma mark - initializer
/**
 * construct
 * @param username username
 * @param password password
 * @return id
 */
- (id)initWithUsername:(NSString *)u
              password:(NSString *)p
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    // RSS Readerに新しくログインする場合、他のRSS関連の通信をすべて止める
    [[JBRSSOperationQueue defaultQueue] cancelAllOperations];

    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        NSError *loginError = error;
        NSInteger loginErrorCode = http::statusCode::SUCCESS;
        loginErrorCode = (loginError) ? loginError.code : loginErrorCode;
        loginErrorCode = (response.statusCode >= http::statusCode::ERROR) ? response.statusCode : loginErrorCode;

        // セッションを持っているか
        if (loginErrorCode == http::statusCode::SUCCESS) {
           BOOL hasSession = [[NSHTTPCookieStorage sharedHTTPCookieStorage] hasCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                                        domains:kSessionDomainsLivedoorReaderLogin];
            if (hasSession == NO) { loginErrorCode = http::statusCode::UNAUTHORIZED; }
        }

        // 失敗
        if (loginErrorCode >= http::statusCode::ERROR) {
            loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                    code:loginErrorCode
                                                userInfo:@{}];;
        }

        h(response, object, loginError);

        if (loginError) {
            // ログインに失敗した場合、他のRSS関連の通信をすべて止める
            [[JBRSSOperationQueue defaultQueue] cancelAllOperations];

            // 失敗をステータスバーに表示
            dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"Authentication failed", @"失敗")
                                                                      duration:1.5f
                                                                      animated:YES];
            });
        }
        else {
            // 成功をステータスバーに表示
            dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:NSLocalizedString(@"Authentication succeeded", @"成功")
                                                                       duration:1.5f
                                                                       animated:YES];
            });
        }
    };

    self = [super initWithRequest:[NSMutableURLRequest JBRSSLoginRequestWithLivedoorID:u
                                                                              password:p]
                          handler:handler];
    if (self) {
        self.username = u;
        self.password = p;
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

    // ステータスバーにログイン中の表示
    dispatch_async(dispatch_get_main_queue(), ^ () {
        [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Authorizing...", @"ログイン中")
                                                animated:YES];
    });

    [super start];
}


#pragma mark - private api


@end

