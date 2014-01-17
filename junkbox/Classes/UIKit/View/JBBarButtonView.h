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
/// ボタン
@property (nonatomic, strong) IBOutlet UIButton *button;

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


@end
