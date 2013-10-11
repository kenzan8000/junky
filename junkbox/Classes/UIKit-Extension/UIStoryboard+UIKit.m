#import "UIStoryboard+UIKit.h"


#pragma mark - UIStoryboard+UIKit
@implementation UIStoryboard (UIKIt)


#pragma mark - class method
+ (id)UIKitFromName:(NSString *)name
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:name
                                                 bundle:nil];
    return [sb instantiateInitialViewController];
}


@end
