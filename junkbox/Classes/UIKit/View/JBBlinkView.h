#pragma mark - JBBlinkView
/// 画面全体を点滅させる
@interface JBBlinkView : UIView {
}


#pragma mark - property
/// 回数
@property (nonatomic, assign) NSInteger blinkCount;
/// 間隔
@property (nonatomic, assign) CGFloat blinkInterval;


#pragma mark - class method
/**
 * 画面を点滅させる
 * @param color color
 * @param count count
 * @param interval interval
 */
+ (void)showBlinkWithColor:(UIColor *)color
                     count:(NSInteger)count
                  interval:(CGFloat)interval;


@end
