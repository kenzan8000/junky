#import "NSURLRequest+JBRSS.h"
#import "JBRSSConstant.h"
/// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSURLRequest+JBRSS
@implementation NSMutableURLRequest (JBRSS)


#pragma mark - api
+ (NSMutableURLRequest *)JBRSSLoginRequestWithLivedoorID:(NSString *)livedoorID
                                                password:(NSString *)password
{
    NSString *URLString = [NSString stringWithFormat:kURLLivedoorReaderLogin, livedoorID, password];
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
    return request;
}

+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest
{
    NSString *apiKey = [[NSHTTPCookieStorage sharedHTTPCookieStorage] valueWithName:kApiKeyLivedoorReader
                                                                             domain:kApiKeyDomainLivedoorReader];

    NSString *URLString = [NSString stringWithFormat:@"%@%@",
        kAPILivedoorReaderSubsUnread,
        [NSString stringWithFormat:kQueryLivedoorReaderApiKey, apiKey]
    ];
    return [NSMutableURLRequest JBPostRequestWithURL:[NSURL URLWithString:URLString]];
}


@end
