#pragma mark - class
@class JBNavigationBarTitleView;


#pragma mark - JBNavigationBarTitleViewDelegate
/// JBNavigationBarTitleViewDelegate
@protocol JBNavigationBarTitleViewDelegate <NSObject>


/**
 * タイトルボタン押下
 * @param titleView titleView
 */
- (void)touchedUpInsideTitleButtonWithNavigationBarTitleViewDelegate:(JBNavigationBarTitleView *)titleView;



@end


#pragma mark - JBNavigationBarTitleView
/// ナビゲーションバータイトル
@interface JBNavigationBarTitleView : UIView {
}


#pragma mark - property
/// タイトル(ラベルの場合・デフォルト)
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/// タイトル(ボタンの場合)
@property (nonatomic, weak) IBOutlet UIButton *titleButton;

/// Delegate タイトルボタン押下
@property (nonatomic, weak) id<JBNavigationBarTitleViewDelegate> delegate;


#pragma mark - event listener
/**
 * タイトルボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithTitleButton:(UIButton *)button;


#pragma mark - api
/**
 * タイトルセット
 * @param title title
 */
- (void)setTitle:(NSString *)title;

/**
 * タイトルにラベルを使用
 */
- (void)useLabel;

/**
 * タイトルにボタンを使用
 */
- (void)useButton;


@end
