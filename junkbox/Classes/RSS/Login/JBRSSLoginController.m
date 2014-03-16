#import "JBRSSConstant.h"
#import "JBRSSLoginController.h"
#import "JBNavigationBarTitleView.h"
#import "JBRSSLoginOperations.h"
#import "JBRSSOperationQueue.h"
#import "UIViewController+ModalAnimatedTransition.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "Reachability.h"
#import "MTStatusBarOverlay.h"
#import "IonIcons.h"
#import "JBQBFlatButton.h"
/// Pods-Extension
#import "SSGentleAlertView+Junkbox.h"
/// UIKit-Extension
#import "UIBarButtonItem+Space.h"
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"


#pragma mark - JBRSSLoginController
@implementation JBRSSLoginController


#pragma mark - synthesize
@synthesize loginFormView;
@synthesize IDTextField;
@synthesize passwordTextField;
@synthesize IDPlaceholderLabel;
@synthesize passwordPlaceholderLabel;
@synthesize loginButton;
@synthesize forgotPasswordButton;
@synthesize loginOperation;
@synthesize focusedTextField;
@synthesize focusedTextFieldIsChanged;


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
    self.loginOperation = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ナビゲーションバー
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexadecimal:0x4682b4ff];
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Livedoor Reader", @"Livedoor Reader")];
    self.navigationItem.titleView = titleView;
        // 閉じるボタン
    JBBarButtonView *closeButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                               title:nil/*NSLocalizedString(@"Close", @"モーダルを閉じる")*/
                                                                                icon:icon_android_close];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:closeButtonView]]
                                      animated:NO];
        //
    JBBarButtonView *menuButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                              title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                               icon:icon_navicon];
    [menuButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:menuButtonView]]
                                       animated:NO];

    self.IDPlaceholderLabel.text = NSLocalizedString(@"Username", @"ユーザー名");
    self.passwordPlaceholderLabel.text = NSLocalizedString(@"Password", @"パスワード");

    // パスワード
    self.passwordTextField.secureTextEntry = YES;

    self.focusedTextField = self.IDTextField;
    self.focusedTextFieldIsChanged = NO;

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

    self.IDTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderUsername];
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderPassword];

    // ログインボタン
    [self.loginButton setTitle:NSLocalizedString(@"Login", @"ログイン") forState:UIControlStateNormal];
    [self.loginButton setFaceColor:[UIColor colorWithHexadecimal:0xff7058ff] forState:UIControlStateNormal];
    [self.loginButton setFaceColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateHighlighted];
    [self.loginButton setSideColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateNormal];
    [self.loginButton setSideColor:[UIColor colorWithHexadecimal:0xc0392bff] forState:UIControlStateHighlighted];
    BOOL isTextfieldEnough = [self isTextfieldEnoughWithUsername:self.IDTextField.text
                                                        password:self.passwordTextField.text];
    [self designLoginButtonWithIsTextfieldEnough:isTextfieldEnough];

    // forgotPasswordButton
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"Forgot password?", @"パスワード忘れた場合のボタンラベル") forState:UIControlStateNormal];
        // 下線
    NSDictionary *attributes = @{
        NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                  NSFontAttributeName:self.forgotPasswordButton.titleLabel.font,
    };
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self.forgotPasswordButton.titleLabel.text
                                                                          attributes:attributes];
    [self.forgotPasswordButton.titleLabel setAttributedText:attributeString];
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
    self.focusedTextFieldIsChanged = (self.focusedTextField != textField);
    self.focusedTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string
{
    // バックスペースで文字が全消しされる場合
    BOOL isClearAll = NO;
    // テキストフィールドがpassword欄で
    // フォーカスするtextFieldが切り替わったばかりで
    // バックススペースが押された
    if (textField == self.passwordTextField &&
        self.focusedTextFieldIsChanged &&
        (string == nil || [string isKindOfClass:[NSString class]] == NO || [string isEqualToString:@""])) {
        isClearAll = YES;
    }
    self.focusedTextFieldIsChanged = NO;

    // 入力後の文字
    NSMutableString *afterString = (self.IDTextField == textField) ?
        self.IDTextField.text.mutableCopy : self.passwordTextField.text.mutableCopy;
    [afterString replaceCharactersInRange:range
                               withString:string];
    if (isClearAll) { afterString = [NSMutableString stringWithCapacity:0]; }

    // ユーザー名とパスワードの入力の状態からログインボタンのデザイン決定
    NSString *username = (self.IDTextField == textField) ? afterString : self.IDTextField.text;
    NSString *password = (self.passwordTextField == textField) ? afterString : self.passwordTextField.text;
    BOOL isTextfieldEnough = [self isTextfieldEnoughWithUsername:username
                                                        password:password];
    [self designLoginButtonWithIsTextfieldEnough:isTextfieldEnough];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self designLoginButtonWithIsTextfieldEnough:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.IDTextField) {
        self.focusedTextFieldIsChanged = YES;
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


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    [self.navigationController dismissViewControllerJBAnimated:YES
                                                    completion:^ () {}];
}


#pragma mark - notification
/**
 * キーボード表示
 * @param notification notification
 **/
- (void)keyboardWillShow:(NSNotification *)notification
{
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
        [SSGentleAlertView showWithMessage:NSLocalizedString(@"Input username", @"ユーザー名が未入力の場合")
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

- (IBAction)touchedUpInsideWithForgotPasswordButton:(UIButton *)button
{
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

    // ネットワークに接続できる場合
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.navigationController dismissViewControllerJBAnimated:YES
                                                        completion:^ () {}];
        // ステータスバーにログイン中の表示
        dispatch_async(dispatch_get_main_queue(), ^ () {
            [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Livedoor Reader Authorizing...", @"ログイン中")
                                                    animated:YES];
        });
    }

    // ログイン処理
    __weak __typeof(self) weakSelf = self;
    JBRSSLoginOperations *operation = [[JBRSSLoginOperations alloc] initWithUsername:self.IDTextField.text
                                                                            password:self.passwordTextField.text
                                                                             handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            // ステータスバーに表示
            dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:NSLocalizedString(@"Authentication succeeded", @"成功")
                                                                       duration:2.5f
                                                                       animated:YES];
            });
            // イベント
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginSuccess
                                                                object:nil
                                                              userInfo:@{}];
            [weakSelf setLoginOperation:nil];
            return;
        }
        // 失敗
        NSString *alertViewMessage = nil;
        NSArray *alertViewButtons = @[NSLocalizedString(@"Confirm", @"確認")];
        switch (error.code) {
            case http::statusCode::UNAUTHORIZED:
                alertViewMessage = NSLocalizedString(@"Your ID and password could not be authenticated. Double check that you entered them correctly and try again.", @"IDかパスワードが違う場合");
                alertViewButtons = @[NSLocalizedString(@"Forgot password?", @"パスワードを忘れた"), NSLocalizedString(@"Confirm", @"確認")];
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
        dispatch_async(dispatch_get_main_queue(), ^ () {
            // アラート
            [SSGentleAlertView showWithMessage:alertViewMessage
                                  buttonTitles:alertViewButtons
                                      delegate:weakSelf];
            // ステータスバー
            [[MTStatusBarOverlay sharedInstance] hide];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginFailure
                                                            object:nil
                                                          userInfo:@{}];
        [weakSelf setLoginOperation:nil];
    }];
    self.loginOperation = operation;
    [operation start];
}

/**
 * ログインに必要な入力情報が足りているかかどうか
 * @param username username
 * @param password password
 * return BOOL
 */
- (BOOL)isTextfieldEnoughWithUsername:(NSString *)username
                             password:(NSString *)password
{
    BOOL isEnough = YES;
    // ユーザー名未入力
    isEnough = isEnough && ([username isEqualToString:@""] == NO);
    // パスワード未入力
    isEnough = isEnough && ([password isEqualToString:@""] == NO);
    return isEnough;
}

/**
 * ログインに必要な入力情報が足りている時といない時のloginButtonの見た目調整
 * @param isTextfieldEnough 足りてるかどうか
 */
- (void)designLoginButtonWithIsTextfieldEnough:(BOOL)isTextfieldEnough
{
    if (isTextfieldEnough) {
        self.loginButton.margin = 2.0f;
        self.loginButton.depth = 2.0f;

        self.loginButton.alpha = 1.0f;
    }
    else {
        self.loginButton.margin = 0.0f;
        self.loginButton.depth = 0.0f;

        self.loginButton.alpha = 0.5f;
    }
    [self.loginButton setNeedsDisplay];
}


@end
