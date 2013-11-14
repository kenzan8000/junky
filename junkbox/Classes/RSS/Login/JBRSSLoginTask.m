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


#pragma mark - initializer



#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api (Livedoor Reader)
-(void)livedoorReaderLoginWithLivedoorID:(NSString *)livedoorID
                                password:(NSString *)password
                                 handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler
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
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSLoginRequestWithLivedoorID:livedoorID
                                                                               password:password];
    [ISHTTPOperation sendRequest:request
                         handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        NSError *loginError = error;
        BOOL fail = (loginError || response.statusCode >= http::statusCode::ERROR) ? YES : NO;

        // セッションを持っているか
        if (fail == NO) {
            fail = ![[NSHTTPCookieStorage sharedHTTPCookieStorage] hasCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                              domains:kSessionDomainsLivedoorReaderLogin];
        }

        // 失敗
        if (fail) {
            loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                    code:response.statusCode
                                                userInfo:@{}];;
        }

        handler(response, object, loginError);
    }];
}


#pragma mark - private api


@end

