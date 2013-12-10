#pragma mark - JBRSSLoginController
/// ログイン画面
@interface JBRSSLoginController : UIViewController <UITextFieldDelegate> {
}


#pragma mark - property
/// ログインフォーム
@property (nonatomic, weak) IBOutlet UIView *loginFormView;
/// ログインID入力
@property (nonatomic, weak) IBOutlet UITextField *IDTextField;
/// ログインパスワード入力
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
/// ログインID入力欄  placeholder
@property (nonatomic, weak) IBOutlet UILabel *IDPlaceholderLabel;
/// ログインパスワード入力欄 placeholder
@property (nonatomic, weak) IBOutlet UILabel *passwordPlaceholderLabel;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


@end
