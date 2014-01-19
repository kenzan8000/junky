#pragma mark - class
@class JBBarButtonView;


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
@property (nonatomic, weak) IBOutlet UIButton *labelButton;
/// 画像ボタン
@property (nonatomic, weak) IBOutlet UIButton *imageButton;
/// ラベル&画像ボタン
@property (nonatomic, weak) IBOutlet UIButton *labelAndImageButton;

/// Delegate ボタン押下
@property (nonatomic, weak) id<JBBarButtonViewDelegate> delegate;


#pragma mark - event listener
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


@end
