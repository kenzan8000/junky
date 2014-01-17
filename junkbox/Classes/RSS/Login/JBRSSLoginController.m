#import "JBRSSConstant.h"
#import "JBRSSLoginController.h"
#import "JBRSSLoginOperations.h"
#import "JBRSSOperationQueue.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "Reachability.h"
#import "MTStatusBarOverlay.h"
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
@synthesize loginOperation;


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

    // 閉じるボタン
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setFrame:kDefaultNavigationItemFrame];
    [closeButton setTitle:NSLocalizedString(@"Close", @"モーダルを閉じる")
                 forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(touchedUpInsideWithCloseButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:closeButton]]
                                      animated:NO];

    // パスワード
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

    self.IDTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderUsername];
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderPassword];
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
- (IBAction)touchedUpInsideWithCloseButton:(UIButton *)button
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

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

    // ネットワークに接続できる場合
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        // ステータスバーにログイン中の表示
        dispatch_async(dispatch_get_main_queue(), ^ () {
            [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Authorizing...", @"ログイン中")
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
                                                                       duration:1.5f
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


@end

