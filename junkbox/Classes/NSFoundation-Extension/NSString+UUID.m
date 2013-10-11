#import "NSString+UUID.h"
#import <uuid/uuid.h>


#pragma mark - NSString+UUID
@implementation NSString (UUID)


#pragma mark - api
+ (NSString *)UUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);

#if __has_feature(objc_arc)
    CFStringRef uuidStringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *uuidString = (__bridge NSString *)uuidStringRef;
#else
    NSString *uuidString = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef) autorelease];
#endif
    if(uuidRef != NULL) {
        CFRelease(uuidRef);
    }

#if __has_feature(objc_arc)
    CFBridgingRelease(uuidStringRef);
#endif

    return uuidString;
}


@end
