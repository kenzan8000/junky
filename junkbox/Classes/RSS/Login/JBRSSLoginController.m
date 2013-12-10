#import "JBRSSLoginController.h"
#import "JBRSSLoginTask.h"
/// Connection
#import "StatusCode.h"
/// Pods-Extension
#import "SSGentleAlertView+Junkbox.h"


#pragma mark - JBRSSLoginController
@implementation JBRSSLoginController


#pragma mark - synthesize
@synthesize loginFormView;
@synthesize IDTextField;
@synthesize passwordTextField;
@synthesize IDPlaceholderLabel;
@synthesize passwordPlaceholderLabel;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.closeButton = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    self.passwordTextField.secureTextEntry = YES;
    // keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // login
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginWillStart:)
                                                 name:kNotificationRSSLoginStart
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidFailure:)
                                                 name:kNotificationRSSLoginFailure
                                               object:nil];
    [self.IDTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.IDTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self touchedUpInsideWithLoginButton:nil];
    }
    return YES;
}


#pragma mark - SSGentleAlertViewDelegate
- (void)alertView:(SSGentleAlertView *)alertView
clickedButtonAtIndex:(NSInteger)index
{

}


#pragma mark - notification
/**
 * キーボード表示
 * @param notification notification
 **/
- (void)keyboardWillShow:(NSNotification *)notification
{
    // キーボードの大きさに合わせて、入力欄の位置を調整
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self designFormWithHeight:keyboardFrame.origin.y];
}

/**
 * ログイン開始
 * @param notification notification
 **/
- (void)loginWillStart:(NSNotification *)notification
{
}

/**
 * ログイン失敗
 * @param notification notification
 **/
- (void)loginDidFailure:(NSNotification *)notification
{
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button
{
    BOOL canStartLogin = YES;

    // ユーザー名未入力
    canStartLogin = canStartLogin && ([self.IDTextField.text isEqualToString:@""] == NO);
    if (canStartLogin == NO) {
        [SSGentleAlertView showWithMessage:NSLocalizedString(@"Input ID", @"IDが未入力の場合")
                              buttonTitles:@[NSLocalizedString(@"Confirm", @"確認")]
                                  delegate:nil];
        return;
    }
    // パスワード未入力
    canStartLogin = canStartLogin && ([self.passwordTextField.text isEqualToString:@""] == NO);
    if (canStartLogin == NO) {
        [SSGentleAlertView showWithMessage:NSLocalizedString(@"Input password", @"パスワードが未入力の場合")
                              buttonTitles:@[NSLocalizedString(@"Confirm", @"確認")]
                                  delegate:nil];
        return;
    }

    // ログイン
    if (canStartLogin) {
        [self login];
    }
}


#pragma mark - private api
/**
 * ログイン
 */
- (void)login
{
    // ログイン開始
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginStart
                                                        object:nil
                                                      userInfo:@{}];

    // ログイン処理
    __block __weak typeof(self) bself = self;
    JBRSSLoginTask *loginTask = [JBRSSLoginTask new];
    [loginTask livedoorReaderLoginWithLivedoorID:self.IDTextField.text
                                        password:self.passwordTextField.text
                                         handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            [bself.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginSuccess
                                                                object:nil
                                                              userInfo:@{}];
            return;
        }

        // 失敗
        NSString *alertViewMessage = nil;
        NSArray *alertViewButtons = @[NSLocalizedString(@"Confirm", @"確認")];
        id alertViewDelegate = nil;
        switch (error.code) {
            case http::statusCode::UNAUTHORIZED:
                alertViewMessage = NSLocalizedString(@"Your ID and password could not be authenticated. Double check that you entered them correctly and try again.", @"IDかパスワードが違う場合");
                alertViewButtons = @[NSLocalizedString(@"Forgot password?", @"パスワードを忘れた"), NSLocalizedString(@"Confirm", @"確認")];
                alertViewDelegate = self;
                break;
            case http::NOT_REACHABLE:
                alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"通信できない");
                break;
            case http::TIMEOUT:
                alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"タイムアウト");
                break;
            default:
                // 4xx
                if (error.code < http::statusCode::SERVER_ERROR) {
                    alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"4xx");
                }
                // 5xx
                else {
                    alertViewMessage = NSLocalizedString(@"Failure occurred in the system. Place the time and try again.", @"5xx");
                }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginFailure
                                                            object:nil
                                                          userInfo:@{}];
        [SSGentleAlertView showWithMessage:alertViewMessage
                              buttonTitles:alertViewButtons
                                  delegate:alertViewDelegate];
    }];
}

/**
 * ログインフォームを変形させる
 * @param height フォームの高さ
 */
- (void)designFormWithHeight:(CGFloat)height
{
    CGRect newFrame = self.loginFormView.frame;
    newFrame.size.height = height;
    self.loginFormView.frame = newFrame;
}


@end
