#import "UIBarButtonItem+Space.h"


#pragma mark - UIBarButtonItem+Space
@implementation UIBarButtonItem (Space)


#pragma mark - class method
+ (UIBarButtonItem *)spaceBarButtonItemWithWidth:(CGFloat)width
{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    spacer.width = width;
    return spacer;
}


@end
