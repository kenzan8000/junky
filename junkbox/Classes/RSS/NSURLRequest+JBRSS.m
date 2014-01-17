#import "NSURLRequest+JBRSS.h"
#import "JBRSSConstant.h"
/// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSURLRequest+JBRSS
@implementation NSMutableURLRequest (JBRSS)


#pragma mark - api
+ (NSMutableURLRequest *)JBRSSLoginRequest1WithLivedoorID:(NSString *)livedoorID
                                                password:(NSString *)password
{
    NSString *URLString = [NSString stringWithFormat:@"%@?livedoor_id=%@&password=%@", kURLLivedoorReaderLogin1, livedoorID, password];
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSLoginRequest2WithLivedoorID:(NSString *)livedoorID
                                                password:(NSString *)password
{
    NSString *URLString = [NSString stringWithFormat:@"%@?livedoor_id=%@&password=%@", kURLLivedoorReaderLogin2, livedoorID, password];
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSLoginRequest3WithLivedoorID:(NSString *)livedoorID
                                                password:(NSString *)password
{
    NSString *URLString = [NSString stringWithFormat:@"%@?livedoor_id=%@&password=%@", kURLLivedoorReaderLogin3, livedoorID, password];
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        kAPILivedoorReaderSubsUnread,
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    return [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
}

+ (NSMutableURLRequest *)JBRSSUnreadRequestWithSubscribeId:(NSString *)subscribeId
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        [NSString stringWithFormat:kAPILivedoorReaderUnread, subscribeId],
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    return [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
}


#pragma mark - private api
/**
 * Livedoor reader POST Request
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSPostRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:URL];
    [request setSessions];
    return request;
}

/**
 * livedoor reader API Key Query文字列取得
 * @return APIKey
 */
+ (NSString *)queryStringLivedoorReaderAPIKey
{
    NSString *apiKey = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderApiKey];
    return [NSString stringWithFormat:kQueryLivedoorReaderApiKey, apiKey];
}

/**
 * LivedoorReaderのセッションをセット
 * session format:cookie名=value;
 */
- (void)setSessions
{
    NSString *sessions = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderSession];
    if (sessions == nil) { return; }

    NSString *cookieString = [NSString stringWithFormat:@"%@", sessions];
    [self setValue:cookieString
forHTTPHeaderField:@"Cookie"];
}


@end
