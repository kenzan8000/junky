#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSHTTPCookieStorage+Cookie
@implementation NSHTTPCookieStorage (Cookie)


#pragma mark - api
- (BOOL)hasCookieWithNames:(NSArray *)names
                   domains:(NSArray *)domains
{
    if ([names count] != [domains count]) { return NO; }

    NSInteger count = [names count];
    NSInteger hasCount = 0;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        for (NSInteger i = 0; i < count; i++) {
            if ([[cookie name] isEqualToString:names[i]] == NO) { continue; }
            if ([[cookie domain] isEqualToString:domains[i]]) { hasCount++; }
        }
    }
    return (count == hasCount);
}

- (void)deleteCookieWithNames:(NSArray *)names
                      domains:(NSArray *)domains
{
    if ([names count] != [domains count]) { return; }

    NSInteger count = [names count];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        for (NSInteger i = 0; i < count; i++) {
            if ([[cookie name] isEqualToString:names[i]] == NO) { continue; }
            if ([[cookie domain] isEqualToString:domains[i]] == NO) { continue; }
            [cookies addObject:cookie];
        }
    }
    for (NSHTTPCookie *cookie in cookies) {
        [storage deleteCookie:cookie];
    }
}

- (NSString *)valueWithName:(NSString *)name
                     domain:(NSString *)domain
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie name] isEqualToString:name] == NO) { continue; }
        if ([[cookie domain] isEqualToString:domain]) { return [cookie value]; }
    }
    return nil;
}

- (void)addCookiesWithURLResponse:(NSURLResponse *)URLResponse
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)URLResponse;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields
                                                              forURL:URLResponse.URL];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookies) { [storage setCookie:cookie]; }
}


@end
