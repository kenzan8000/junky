#pragma mark - JBRSSLoginController
/// ログイン画面
@interface JBRSSLoginController : UIViewController <UITextFieldDelegate> {
}


#pragma mark - property
/// livedoor id入力
@property (nonatomic, weak) IBOutlet UITextField *livedoorIdTextField;
/// password 入力
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
/// livedoor id placeholder
@property (nonatomic, weak) IBOutlet UILabel *livedoorIdPlaceholderLabel;
/// password placeholder
@property (nonatomic, weak) IBOutlet UILabel *passwordPlaceholderLabel;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


@end
