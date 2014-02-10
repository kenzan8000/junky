#pragma mark - class
@class JBBarButtonView;
@class SAMBadgeView;
@class JBQBFlatButton;


#pragma mark - JBBarButtonViewDelegate
/// JBBarButtonViewDelegate
@protocol JBBarButtonViewDelegate <NSObject>


/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView;



@end


#pragma mark - JBBarButtonView
/// CustomバーボタンItem
@interface JBBarButtonView : UIView {
}


#pragma mark - property
/// ラベルボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *labelButton;
/// 画像ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *imageButton;
/// ラベル&画像ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *labelAndImageButton;
/// バッジ
@property (nonatomic, weak) IBOutlet SAMBadgeView *badgeView;

/// Delegate ボタン押下
@property (nonatomic, weak) id<JBBarButtonViewDelegate> delegate;


#pragma mark - event listener
/**
 * デフォルトのバーボタンを生成
 * @param del delegate
 * @param title ボタンのtitle
 * @param icon ioiconsの名前
 * @return barButtonView
 */
+ (JBBarButtonView *)defaultBarButtonWithDelegate:(id<JBBarButtonViewDelegate>)del
                                            title:(NSString *)title
                                             icon:(NSString *)icon;

/**
 * デフォルトのバーボタンを生成
 * @param del delegate
 * @param title ボタンのtitle
 * @param icon ioiconsの名前
 * @param color color
 * @return barButtonView
 */
+ (JBBarButtonView *)defaultBarButtonWithDelegate:(id<JBBarButtonViewDelegate>)del
                                            title:(NSString *)title
                                             icon:(NSString *)icon
                                            color:(UIColor *)color;

/**
 * ボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


#pragma mark - api
/**
 * タイトルセット
 * @param title title
 */
- (void)setTitle:(NSString *)title;

/**
 * フォントセット
 * @param font font
 */
- (void)setFont:(UIFont *)font;

/**
 * タイトル、画像をセット
 * @param title title
 * @param image image
 * @param state UIControlState
 */
- (void)setTitle:(NSString *)title
           image:(UIImage *)image
        forState:(UIControlState)state;

/**
 * タイトル、フォント、画像をセット
 * @param title title
 * @param font font
 * @param image image
 * @param state UIControlState
 */
- (void)setTitle:(NSString *)title
            font:(UIFont *)font
           image:(UIImage *)image
        forState:(UIControlState)state;

/**
 * 画像セット
 * @param image image
 * @param state UIControlState
 */
- (void)setImage:(UIImage *)image
        forState:(UIControlState)state;

/**
 * バッジにテキストと色をセット
 * @param text string
 * @param color color
 */
- (void)setBadgeText:(NSString *)text
               color:(UIColor *)color;


@end
