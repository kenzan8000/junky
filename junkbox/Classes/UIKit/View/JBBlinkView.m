#import "JBBlinkView.h"


#pragma mark - JBBlinkView
@implementation JBBlinkView


#pragma mark - property
@synthesize blinkCount;
@synthesize blinkInterval;


#pragma mark - class method
+ (void)showBlinkWithColor:(UIColor *)color
                     count:(NSInteger)count
                  interval:(CGFloat)interval
{
    JBBlinkView *view = [JBBlinkView new];

    // 設定
    [view setBackgroundColor:color];
    view.blinkCount = count;
    view.blinkInterval = interval;

    // 配置
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [window addSubview:view];

    // アニメーション
    [view blinkOn];
}


#pragma mark - private api
/**
 * 点
 */
- (void)blinkOn
{
    __weak __typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^ () {

        weakSelf.blinkCount--;
        weakSelf.alpha = 0;

        // アニメーション
        [UIView animateWithDuration:self.blinkInterval
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ () {
            weakSelf.alpha = 1;
        }
                         completion:^ (BOOL finished) {
            [weakSelf blinkOff];
        }];

    });
}

/**
 * 滅
 */
- (void)blinkOff
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {

        weakSelf.alpha = 1;

        // アニメーション
        [UIView animateWithDuration:blinkInterval
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^ () {
            weakSelf.alpha = 0;
        }
                         completion:^ (BOOL finished) {
            if (weakSelf.blinkCount <= 0) {
                [weakSelf removeFromSuperview];
            }
            else {
                [weakSelf blinkOn];
            }
        }];

    });
}


@end
