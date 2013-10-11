#pragma mark - NSNull+IgnoreMessages
@interface NSNull (IgnoreMessages)


#pragma makr - api
- (void)forwardInvocation:(NSInvocation *)anInvocation;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;


@end

