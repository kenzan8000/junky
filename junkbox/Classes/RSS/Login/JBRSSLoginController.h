#import "JBBarButtonView.h"


#pragma mark - class
@class JBRSSLoginOperations;
@class QBFlatButton;


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
@property (nonatomic, weak) IBOutlet QBFlatButton *loginButton;
/// ログイン処理
@property (nonatomic, strong) JBRSSLoginOperations *loginOperation;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


@end
