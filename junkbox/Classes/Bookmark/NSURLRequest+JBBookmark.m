#import "NSURLRequest+JBBookmark.h"
#import "JBBookmarkConstant.h"
/// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSURLRequest+JBBookmark
@implementation NSMutableURLRequest (JBBookmark)


#pragma mark - api
+ (NSMutableURLRequest *)JBBookmarkCatalogRequest
{
    NSString *URLString = kAPIHatenaBookmarkDump;
    return [NSMutableURLRequest JBBookmarkPostRequestWithURL:[NSURL URLWithString:URLString]];
}


#pragma mark - private api
/**
 * Livedoor reader POST Request
 * @return request
 */
+ (NSMutableURLRequest *)JBBookmarkPostRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest JBPostRequestWithURL:URL];
    [request setSessions];
    return request;
}

/**
 * LivedoorReaderのセッションをセット
 * session format:cookie名=value;
 */
- (void)setSessions
{
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookieString = [NSMutableString stringWithCapacity:0];
    for (NSHTTPCookie* cookie in [storage cookies]) {
        [cookieString appendFormat:@"%@=%@;", [cookie name], [cookie value]];
    }

    [self setValue:cookieString
forHTTPHeaderField:@"Cookie"];
}


@end
