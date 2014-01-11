#import "JBLoginOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation+Extension
#import "NSHTTPCookieStorage+Cookie.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBLoginOperation
@implementation JBLoginOperation


#pragma mark - synthesize
@synthesize username;
@synthesize password;
@synthesize cookieNames;
@synthesize cookieDomains;


#pragma mark - initializer
- (id)initWithUsername:(NSString *)u
              password:(NSString *)p
           cookieNames:(NSArray *)names
         cookieDomains:(NSArray *)domains
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
               request:(NSURLRequest *)request;
{
    // 通信後の処理
    void (^ handler)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] addCookiesWithURLResponse:response];

        NSError *loginError = error;
        NSInteger loginErrorCode = http::statusCode::SUCCESS;
        loginErrorCode = (loginError) ? loginError.code : loginErrorCode;
        loginErrorCode = (response.statusCode >= http::statusCode::ERROR) ? response.statusCode : loginErrorCode;

        // 失敗
        if (loginErrorCode >= http::statusCode::ERROR) {
            loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                    code:loginErrorCode
                                                userInfo:@{}];;
        }
        else {
           BOOL hasSession = [[NSHTTPCookieStorage sharedHTTPCookieStorage] hasCookieWithNames:names
                                                                                       domains:domains];
            if (hasSession == NO) {
                loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                        code:http::statusCode::UNAUTHORIZED
                                                    userInfo:@{}];;
            }
        }

        h(response, object, loginError);
    };

    self = [super initWithRequest:request
                          handler:handler];
    if (self) {
        self.username = u;
        self.password = p;
        self.cookieNames = names;
        self.cookieDomains = domains;
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

