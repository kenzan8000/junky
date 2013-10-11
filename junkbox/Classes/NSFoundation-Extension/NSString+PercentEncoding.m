#import "NSString+PercentEncoding.h"


#pragma mark - NSString+PercentEncoding
@implementation NSString (PercentEncoding)


#pragma mark - api
- (NSString *)escapeString
{
#if __has_feature(objc_arc)
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (__bridge CFStringRef)self,
        (__bridge CFStringRef)@"*+-./@_",
        (__bridge CFStringRef)@" !\"#$%&'(),:;<=>?[\\]^`{|}~",
        kCFStringEncodingUTF8
    ));
#else
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR("*+-./@_"),
        CFSTR(" !\"#$%&'(),:;<=>?[\\]^`{|}~"),
        kCFStringEncodingUTF8
    ) autorelease];
#endif
}

- (NSString *)encodeURIString
{
#if __has_feature(objc_arc)
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (__bridge CFStringRef)self,
        (__bridge CFStringRef)@"!#$&'()*+,-./:;=?@_~",
        (__bridge CFStringRef)@" \"%<>[\\]^`{|}",
        kCFStringEncodingUTF8
    ));
#else
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR("!#$&'()*+,-./:;=?@_~"),
        CFSTR(" \"%<>[\\]^`{|}"),
        kCFStringEncodingUTF8
    ) autorelease];
#endif
}

- (NSString *)encodeURIComponentString
{
#if __has_feature(objc_arc)
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (__bridge CFStringRef)self,
        (__bridge CFStringRef)@"!'()*-._~",
        (__bridge CFStringRef)@" \"#$%&+,/:;<=>?@[\\]^`{|}",
        kCFStringEncodingUTF8
    ));
#else
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR("!'()*-._~"),
        CFSTR(" \"#$%&+,/:;<=>?@[\\]^`{|}"),
        kCFStringEncodingUTF8
    ) autorelease];
#endif
}

- (NSString *)decodeURIComponentString
{
#if __has_feature(objc_arc)
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
        kCFAllocatorDefault,
        (__bridge CFStringRef)self,
        CFSTR(""),
        kCFStringEncodingUTF8
    ));
#else
    return [(NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
        kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR(""),
        kCFStringEncodingUTF8l
    ) autorelease];
#endif
}


@end
