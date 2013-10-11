#import "NSURLRequest+JBRSS.h"
#import "JBRSSConstant.h"
/// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSURLRequest+JBRSS
@implementation NSMutableURLRequest (JBRSS)


#pragma mark - api
+ (NSMutableURLRequest *)JBRSSLoginRequestWithLivedoorId:(NSString *)livedoorId
                                                password:(NSString *)password
{
    NSString *URLString = [NSString stringWithFormat:kURLLivedoorReaderLogin, livedoorId, password];
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest
{
    NSString *apiKey = [[NSHTTPCookieStorage sharedHTTPCookieStorage] valueWithName:kSessionNameLivedoorReaderLogin domain:kSessionDomainLivedoorReaderLogin];

    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        kAPILivedoorReaderSubsUnread,
        [NSString stringWithFormat:kQueryLivedoorReaderApiKey, apiKey]
    ];
    return [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
}


@end

