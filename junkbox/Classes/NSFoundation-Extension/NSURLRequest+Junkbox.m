#import "NSURLRequest+Junkbox.h"
// NSFoundation-Extension
#import "NSDictionary+HTTPBody.h"


#pragma mark - NSURLRequest+Junkbox
@implementation NSMutableURLRequest (Junkbox)


#pragma mark - api
+ (NSMutableURLRequest *)JBRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    return request;
}

+ (NSMutableURLRequest *)JBPostRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest JBRequestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"0"
   forHTTPHeaderField:@"Content-Length"];

    return request;
}

+ (NSMutableURLRequest *)JBPostRequestWithURL:(NSURL *)url
                                   parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest JBRequestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];

    NSData *HTTPBody = [parameters HTTPBodyValue];
    [request setValue:[NSString stringWithFormat:@"%d", [HTTPBody length]]
   forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:HTTPBody];

    return request;
}


#pragma mark - private api
- (void)setCookies
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
