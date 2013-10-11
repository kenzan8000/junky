#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - NSHTTPCookieStorage+Cookie
@implementation NSHTTPCookieStorage (Cookie)


#pragma mark - api
- (BOOL)hasCookieWithName:(NSString *)name
                   domain:(NSString *)domain
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie name] isEqualToString:name] == NO) { continue; }
        if ([[cookie domain] isEqualToString:domain]) { return YES; }
    }
    return NO;
}

- (void)deleteCookieWithName:(NSString *)name
                      domain:(NSString *)domain
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie name] isEqualToString:name] == NO) { continue; }
        if ([[cookie domain] isEqualToString:domain] == NO) { continue; }
        [cookies addObject:cookie];
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

@end
