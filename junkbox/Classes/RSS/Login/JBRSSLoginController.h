#import "JBBarButtonView.h"


#pragma mark - class
@class JBRSSLoginOperations;
@class JBQBFlatButton;


#pragma mark - JBRSSLoginController
/// ログイン画面
@interface JBRSSLoginController : UIViewController <UITextFieldDelegate, JBBarButtonViewDelegate> {
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
/// ログインボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *loginButton;
/// Forgot password?ボタン
@property (nonatomic, weak) IBOutlet UIButton *forgotPasswordButton;
/// ログイン処理
@property (nonatomic, strong) JBRSSLoginOperations *loginOperation;
/// 現在フォーカスされているtextfield
@property (nonatomic, weak) UITextField *focusedTextField;
/// フォーカスされているtextFieldが切り替わった
@property (nonatomic, assign) BOOL focusedTextFieldIsChanged;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;

/**
 * forgotPasswordButton押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithForgotPasswordButton:(UIButton *)button;


@end
