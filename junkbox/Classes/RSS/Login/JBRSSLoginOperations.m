#import "JBRSSConstant.h"
#import "JBLoginOperation.h"
#import "JBRSSLoginOperations.h"
#import "JBRSSOperationQueue.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSHTTPCookieStorage+Cookie.h"
#import "NSURLRequest+Junkbox.h"
/// Pods
#import "Reachability.h"


#pragma mark - JBRSSLoginOperations
@implementation JBRSSLoginOperations


#pragma mark - synthesize
@synthesize username;
@synthesize password;
@synthesize handler;
@synthesize operations;


#pragma mark - class method
/**
 * エラー処理
 * @param response response
 * @param object object
 * @param error error
 * @return error
 */
+ (NSError *)handleErrorWithResponse:(NSHTTPURLResponse *)response
                              object:(id)object
                               error:(NSError *)error
{
    if (error == nil) {
        return nil;
    }

    // 失敗
    NSError *loginError = error;
    NSInteger errorCode = error.code;
    if (errorCode >= http::statusCode::ERROR) {
        loginError = [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                code:errorCode
                                            userInfo:@{}];
    }

    // ログインに失敗した場合、他のRSS関連の通信をすべて止める
    if (loginError) {
        [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
    }

    return loginError;
}


#pragma mark - initializer
- (id)initWithUsername:(NSString *)u
              password:(NSString *)p
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    self = [super init];
    if (self) {
        self.username = u;
        self.password = p;
        self.handler = h;
        [self createConnectionsWithHandler:h];

        // Username,Password記録
        [[NSUserDefaults standardUserDefaults] setObject:u
                                                  forKey:kUserDefaultsLivedoorReaderUsername];
        [[NSUserDefaults standardUserDefaults] setObject:p
                                                  forKey:kUserDefaultsLivedoorReaderPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

- (id)initReauthenticationWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    self = [self initWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderUsername]
                         password:[[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderPassword]
                          handler:h];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.operations = nil;
    self.handler = NULL;
    self.username = nil;
    self.password = nil;
}


#pragma mark - api
- (void)start
{
    // ネットワークに接続できない
    if ([[Reachability reachabilityForInternetConnection] isReachable] == NO) {
        self.handler(nil,
                     @{},
                     [[NSError alloc] initWithDomain:NSMachErrorDomain
                                                code:http::NOT_REACHABLE
                                                userInfo:@{}]);
        return;
    }
    // RSS Readerに新しくログインする場合、他のRSS関連の通信をすべて止める
    [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
    // セッションクリア
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookieWithNames:kSessionNamesLivedoorReaderLogin
                                                                 domains:kSessionDomainsLivedoorReaderLogin];
    // ログインの時はRSS系の通信スレッド数1
    [[JBRSSOperationQueue defaultQueue] setMaxConcurrentOperationCount:1];

    for (NSInteger i = 0; i < self.operations.count; i++) {
        [[JBRSSOperationQueue defaultQueue] addOperation:self.operations[i]];
    }
}


#pragma mark - private api
/**
 * LivedoorReaderに必要なログインの通信を準備
 */
- (void)createConnectionsWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    // 通信後の処理1
    void (^ h1)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        NSError *loginError = [JBRSSLoginOperations handleErrorWithResponse:response
                                                                     object:object
                                                                      error:error];
        if (loginError) {
            // RSS系の通信スレッド数をデフォルトに戻す
            [[JBRSSOperationQueue defaultQueue] setMaxConcurrentOperationCount:kMaxOperationCountOfRSSConnection];

            h(response, object, loginError);
        }
        else {
            // セッションをセット
            NSMutableString *cookie = [NSMutableString stringWithCapacity:0];
            for (NSInteger i = 0; i < kSessionNamesLivedoorReaderLogin.count; i++) {
                [cookie appendString:[NSString stringWithFormat:@"%@=%@;", kSessionNamesLivedoorReaderLogin[i], [[NSHTTPCookieStorage sharedHTTPCookieStorage] valueWithName:kSessionNamesLivedoorReaderLogin[i] domain:kSessionDomainsLivedoorReaderLogin[i]]]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:cookie
                                                      forKey:kUserDefaultsLivedoorReaderSession];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    };
    // 通信後の処理2
    void (^ h2)(NSHTTPURLResponse *, id, NSError *) = ^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // RSS系の通信スレッド数をデフォルトに戻す
        [[JBRSSOperationQueue defaultQueue] setMaxConcurrentOperationCount:kMaxOperationCountOfRSSConnection];

        NSError *loginError = [JBRSSLoginOperations handleErrorWithResponse:response
                                                                     object:object
                                                                      error:error];

        // ApiKeyをセット
        if (loginError == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] valueWithName:kApiKeyLivedoorReader domain:kApiKeyDomainLivedoorReader]
                                                      forKey:kUserDefaultsLivedoorReaderApiKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        h(response, object, loginError);
    };

    // Connection1
    JBLoginOperation *con1 = [[JBLoginOperation alloc] initWithUsername:self.username
                                                               password:self.password
                                                            cookieNames:kCookieNamesLivedoorReaderLogin
                                                          cookieDomains:kCookieDomainsLivedoorReaderLogin
                                                                handler:h1
                                                                request:[NSMutableURLRequest JBRSSLoginRequest1WithLivedoorID:self.username password:self.password]];
    // Connection2
    JBLoginOperation *con2 = [[JBLoginOperation alloc] initWithUsername:self.username
                                                               password:self.password
                                                            cookieNames:kSessionNamesLivedoorReaderLogin
                                                          cookieDomains:kSessionDomainsLivedoorReaderLogin
                                                                handler:h1
                                                                request:[NSMutableURLRequest JBRSSLoginRequest2WithLivedoorID:self.username password:self.password]];
    // Connection3
    JBLoginOperation *con3 = [[JBLoginOperation alloc] initWithUsername:self.username
                                                               password:self.password
                                                            cookieNames:@[kApiKeyLivedoorReader]
                                                          cookieDomains:@[kApiKeyDomainLivedoorReader]
                                                                handler:h2
                                                                request:[NSMutableURLRequest JBRSSLoginRequest3WithLivedoorID:self.username password:self.password]];

    self.operations = @[con1, con2, con3];
}



@end
