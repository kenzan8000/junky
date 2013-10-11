#import "UINib+UIKit.h"


#pragma mark - UINib+UIKit
@implementation UINib (UIKIt)


#pragma mark - class method
+ (id)UIKitFromClass:(Class)aClass
{
    return [[UINib nibWithNibName:NSStringFromClass(aClass) bundle:nil] instantiateWithOwner:nil options:nil][0];
}

+ (id)UIKitFromClassName:(NSString *)className
{
    return [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil][0];
}


@end
