#import "UIKit+Localize.h"


#pragma mark - UIButton+Localize
@implementation UIButton (Localze)


#pragma mark - api
- (void)setTitleForLocalizedKey:(NSString *)key
{
    [self setTitle:NSLocalizedString(key, nil)
          forState:UIControlStateNormal];
}


@end


#pragma mark - UILabel+Localize
@implementation UILabel (Localze)


#pragma mark - api
- (void)setTextForLocalizedKey:(NSString *)key
{
    [self setText:NSLocalizedString(key, nil)];
}


@end
