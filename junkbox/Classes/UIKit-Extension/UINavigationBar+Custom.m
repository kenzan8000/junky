#import "UINavigationBar+Custom.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - implementation
@implementation UINavigationBar (Custom)


#pragma mark - api
- (void)designDefaultNavigationBar
{
/*
    // 背景・ロゴ
    UIImage *backgroundImage = [UIImage imageNamed:kImageCommonNavigationBarBackground];
    UIImage *logoImage = [UIImage imageNamed:kImageCommonNavigationBarLogo];
    [self setNavigationBarBackgroundImage:backgroundImage
                                logoImage:logoImage];
*/
    //シャドー
    [self setNavigationBarShadow];
}


#pragma mark - private api
/**
 * ナビゲーションバーに背景画像とロゴをセット
 * @param backgroundImage 背景画像
 * @param logoImage ロゴ画像
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage
                              logoImage:(UIImage *)logoImage
{
    // 背景画像
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage
                   forBarMetrics:UIBarMetricsDefault];
    }

    // ロゴ
    if (logoImage) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];

        // サイズ・位置
        CGRect rect = CGRectZero;
        rect.size.width = logoImage.size.width/2;
        rect.size.height = logoImage.size.height/2;
        rect.origin.x = (self.bounds.size.width - logoImage.size.width/2) / 2;
        rect.origin.y = (self.bounds.size.height - logoImage.size.height/2) / 2;
        [logoImageView setFrame:rect];

        [self addSubview:logoImageView];
    }
}

/**
 * ナビゲーションバーの下の影を付ける
 */
- (void)setNavigationBarShadow
{
/*
    // シャドー
    self.layer.shadowOffset = kNavigationBarShadowOffset;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = kNavigationBarShadowOpacity;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
*/
}


@end
