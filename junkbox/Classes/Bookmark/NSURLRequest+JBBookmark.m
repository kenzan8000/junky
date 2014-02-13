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
    [request setBookmarkSessions];
    return request;
}

/**
 * Hatebuのセッションをセット
 * session format:cookie名=value;
 */
- (void)setBookmarkSessions
{
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookieString = [NSMutableString stringWithCapacity:0];
    for (NSHTTPCookie* cookie in [storage cookies]) {
        if ([cookie.domain hasSuffix:kHostHatenaBookmark] == NO) {
            continue;
        }
        [cookieString appendFormat:@"%@=%@;", [cookie name], [cookie value]];
    }

    [self setValue:cookieString
forHTTPHeaderField:@"Cookie"];
}


@end
