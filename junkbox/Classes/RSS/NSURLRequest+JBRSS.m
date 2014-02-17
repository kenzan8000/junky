#import "NSURLRequest+JBRSS.h"
#import "JBRSSConstant.h"
/// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
#import "NSHTTPCookieStorage+Cookie.h"
#import "NSString+PercentEncoding.h"


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

+ (NSMutableURLRequest *)JBRSSFeedDiscoverRequestWithURL:(NSURL *)URL
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        [NSString stringWithFormat:kAPILivedoorReaderFeedDiscover, [[URL absoluteString] encodeURIComponentString]],
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    return [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
}

+ (NSMutableURLRequest *)JBRSSFeedSubscribeRequestWithURL:(NSURL *)URL
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        [NSString stringWithFormat:kAPILivedoorReaderFeedSubscribe, [[URL absoluteString] encodeURIComponentString]],
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    return [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
}

+ (NSMutableURLRequest *)JBRSSFeedSetRateRequestWithSubscribeId:(NSString *)subscribeId
                                                           rate:(NSNumber *)rate
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        [NSString stringWithFormat:kAPILivedoorReaderFeedSetRate, subscribeId, rate],
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    return [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
}

+ (NSMutableURLRequest *)JBRSSAddPinRequestWithTitle:(NSString *)title
                                                link:(NSString *)link
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        [NSString stringWithFormat:kAPILivedoorReaderPinAdd, [title encodeURIComponentString], [link encodeURIComponentString]],
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSRemovePinRequestWithLink:(NSString *)link
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
             [NSString stringWithFormat:kAPILivedoorReaderPinRemove, [link encodeURIComponentString]],
             [NSMutableURLRequest queryStringLivedoorReaderAPIKey]
    ];
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSPinAllRequest
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",
             kAPILivedoorReaderPinAll,
             [NSMutableURLRequest queryStringLivedoorReaderAPIKeyWithIsFirstParameter:YES]
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
    [request setRSSSessions];
    return request;
}

/**
 * livedoor reader API Key Query文字列取得
 * @param isFirstParameter パラメーターが最初のパラメーターかどうか
 * @return APIKey
 */
+ (NSString *)queryStringLivedoorReaderAPIKeyWithIsFirstParameter:(BOOL)isFirstParameter
{
    return (isFirstParameter) ?
        [NSString stringWithFormat:kQueryLivedoorReaderApiKeyFirstParameter, [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderApiKey]] :
        [NSMutableURLRequest queryStringLivedoorReaderAPIKey];
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
- (void)setRSSSessions
{
    NSMutableString *cookieString = [NSMutableString stringWithCapacity:0];

    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies]) {
        if ([cookie.domain hasSuffix:kHostLivedoorReader] == NO) {
            continue;
        }
        [cookieString appendFormat:@"%@=%@;", [cookie name], [cookie value]];
    }

    NSString *sessions = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderSession];
    if (sessions) {
        [cookieString appendString:sessions];
    }

    [self setValue:cookieString
forHTTPHeaderField:@"Cookie"];

}


@end
