#import "JBRSSConstant.h"
#import "JBRSSLoginTask.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
#import "ISHTTPOperation.h"
/// NSFoundation-Extension
#import "NSHTTPCookieStorage+Cookie.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSLoginTask
@implementation JBRSSLoginTask


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
{
    self = [super init];
    if (self) {
        self.username = u;
        self.password = p;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api (Livedoor Reader)
-(void)livedoorReaderLoginWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler
{
    // ネットワークに接続できない
    if ([[Reachability reachabilityForInternetConnection] isReachable] == NO) {
        handler(nil,
                @{},
                [[NSError alloc] initWithDomain:NSMachErrorDomain
                                           code:http::NOT_REACHABLE
                                           userInfo:@{}]);
        return;
    }

    // セッションクリア
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                 domains:kSessionDomainsLivedoorReaderLogin];

    // ログイン
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSLoginRequestWithLivedoorID:self.username
                                                                               password:self.password];
    [ISHTTPOperation sendRequest:request
                         handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
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

        handler(response, object, loginError);
    }];
}


#pragma mark - private api


@end

