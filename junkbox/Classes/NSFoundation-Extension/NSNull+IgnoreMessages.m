#import "NSNull+IgnoreMessages.h"


#pragma mark - NSNull+IgnoreMessages
@implementation NSNull (IgnoreMessages)


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig=[[NSNull class] instanceMethodSignatureForSelector:aSelector];
    // Just return some meaningless signature
    if (sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }

    return sig;
}


@end
