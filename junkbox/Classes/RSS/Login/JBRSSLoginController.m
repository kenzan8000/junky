#import "JBRSSLoginController.h"
#import "JBRSSConstant.h"
#import "NSURLRequest+JBRSS.h"
/// Connection
#import "StatusCode.h"
#import "ISHTTPOperation.h"
/// NSFoundation-Extension
#import "NSHTTPCookieStorage+Cookie.h"


#pragma mark - JBRSSLoginController
@implementation JBRSSLoginController


#pragma mark - synthesize
@synthesize livedoorIdTextField;
@synthesize passwordTextField;
@synthesize livedoorIdPlaceholderLabel;
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
    if (textField == self.livedoorIdTextField) {
        [self.livedoorIdPlaceholderLabel setHidden:YES];
    }
    else if (textField == self.passwordTextField) {
        [self.passwordPlaceholderLabel setHidden:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL hidden = ([textField.text isEqualToString:@""]) ? NO : YES;
    if (textField == self.livedoorIdTextField) {
        [self.livedoorIdPlaceholderLabel setHidden:hidden];
    }
    else if (textField == self.passwordTextField) {
        [self.passwordPlaceholderLabel setHidden:hidden];
    }
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
    if (textField == self.livedoorIdTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self touchedUpInsideWithLoginButton:nil];
    }
    return YES;
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
    [self designFormWithHeight:keyboardFrame.origin.y
                      duration:0.3];
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
    // 未入力
    if ([self.livedoorIdTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        return;
    }

    // ログイン
    [self login];
}


#pragma mark - private api
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // 入力欄以外の場所をタッチ
    if (CGRectContainsPoint(self.livedoorIdTextField.frame, [[[event allTouches] anyObject] locationInView:self.view]) == NO &&
        CGRectContainsPoint(self.passwordTextField.frame, [[[event allTouches] anyObject] locationInView:self.view]) == NO) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height - (self.navigationController.toolbar.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        [self designFormWithHeight:height
                          duration:0.2];

        [self.livedoorIdTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    [super touchesBegan:touches
              withEvent:event];
}

/**
 * ログイン
 */
- (void)login
{
    // ログイン開始
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginStart
                                                        object:nil
                                                      userInfo:@{}];

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookieWithName:kSessionNameLivedoorReaderLogin
                                                                 domain:kSessionDomainLivedoorReaderLogin];
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSLoginRequestWithLivedoorId:self.livedoorIdTextField.text
                                                                               password:self.passwordTextField.text];
    [ISHTTPOperation sendRequest:request
                         handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 失敗
                             BOOL fail = (error || response.statusCode >= http::statusCode::ERROR) ? YES : NO;
        // セッションを持っているか
        if (fail == NO) {
            fail = ![[NSHTTPCookieStorage sharedHTTPCookieStorage] hasCookieWithName:kSessionNameLivedoorReaderLogin
                                                                              domain:kSessionDomainLivedoorReaderLogin];
        }
        if (fail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginFailure
                                                                object:nil
                                                              userInfo:@{}];
            return;
        }

        // 成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRSSLoginSuccess
                                                            object:nil
                                                          userInfo:@{}];
    }];
}

/**
 * ログインフォームを変形させる
 * @param height フォームの高さ
 */
- (void)designFormWithHeight:(CGFloat)height
                    duration:(CGFloat)duration
{
    __block typeof(self) bself = self;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ () {
        CGRect newFrame = bself.view.frame;
        newFrame.size.height = height;
        bself.view.frame = newFrame;
    }
                     completion:^ (BOOL finished) { }];

}


@end
