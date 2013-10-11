#import "UIColor+Hexadecimal.h"


#pragma mark - implementation
@implementation UIColor (Hexadecimal)


#pragma mark - api
+ (UIColor *)colorWithHexadecimal:(NSInteger)hexadecimal
{
    return [UIColor colorWithRed:((hexadecimal & 0xff000000) >> 24) / 255.0
                           green:((hexadecimal & 0x00ff0000) >> 16) / 255.0
                            blue:((hexadecimal & 0x0000ff00) >>  8) / 255.0
                           alpha:( hexadecimal & 0x000000ff       ) / 255.0];
}


@end
