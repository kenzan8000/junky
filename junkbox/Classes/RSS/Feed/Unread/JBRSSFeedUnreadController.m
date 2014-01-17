#import "JBRSSFeedUnreadController.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSLoginOperations.h"
#import "JBRSSOperationQueue.h"
#import "JBWebViewController.h"
/// Connection
#import "StatusCode.h"
/// UIKit=Extension
#import "UIColor+Hexadecimal.h"
/// Pods
#import "MTStatusBarOverlay.h"


#pragma mark - JBRSSFeedUnreadController
@implementation JBRSSFeedUnreadController


#pragma mark - synthesize
@synthesize unreadList;
@synthesize indexOfUnreadList;
@synthesize nextFeedButton;
@synthesize previousButton;
@synthesize nextButton;
@synthesize loginOperation;
@synthesize openingURL;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.indexOfUnreadList = 0;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.unreadList = nil;
    self.loginOperation = nil;
    self.openingURL = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    [self loadWebView];
    [self designPreviousAndNextButton];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kStoryboardSeguePushWebViewController]) {
        JBWebViewController *vc = (JBWebViewController *)[segue destinationViewController];
        [vc setInitialURL:self.openingURL];
    }
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:self.webView
shouldStartLoadWithRequest:request
    navigationType:navigationType];

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self openURL:request.URL];
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [super webViewDidStartLoad:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:self.webView];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [super webView:self.webView
didFailLoadWithError:error];
}


#pragma mark - JBRSSFeedUnreadListDelegate
- (void)unreadListDidFinishLoadWithList:(JBRSSFeedUnreadList *)list
{
}

- (void)unreadListDidFailLoadWithError:(NSError *)error
{
    // エラー処理
    switch (error.code) {
        case http::statusCode::UNAUTHORIZED: // 401
            // 再度ログイン後、フィードのリストをロード
            [self login];
            [self.unreadList loadFeedFromWebAPI];
            break;
        default:
            break;
    }
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithNextFeedButton:(UIButton *)button
{
}

- (IBAction)touchedUpInsideWithPreviousButton:(UIButton *)button
{
    self.indexOfUnreadList--;
    if (self.indexOfUnreadList < 0) { self.indexOfUnreadList = 0; }
    else { [self loadWebView]; }
    [self designPreviousAndNextButton];
}

- (IBAction)touchedUpInsideWithNextButton:(UIButton *)button
{
    self.indexOfUnreadList++;
    if (self.indexOfUnreadList >= [self.unreadList count]) { self.indexOfUnreadList = [self.unreadList count]-1; }
    else { [self loadWebView]; }
    [self designPreviousAndNextButton];
}


#pragma mark - api
- (void)loadWebView
{
    JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
    if (unread) {
        self.navigationItem.title = unread.title;
        [self.webView loadHTMLString:unread.body
                             baseURL:unread.link];
    }
}


#pragma mark - private api
/**
 * 認証切れの場合の再ログイン
 */
- (void)login
{
    __weak __typeof(self) weakSelf = self;
    JBRSSLoginOperations *operation = [[JBRSSLoginOperations alloc] initReauthenticationWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // ログインに失敗した場合、他のRSS関連の通信をすべて止める
        if (error) {
            [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
            // ステータスバー
            [[MTStatusBarOverlay sharedInstance] hide];
        }
        [weakSelf setLoginOperation:nil];
    }];
    self.loginOperation = operation;
    [operation start];
}

/**
 * 次の記事へ、前の記事へボタンデザイン
 */
- (void)designPreviousAndNextButton
{
    UIColor *defaultColor = [UIColor colorWithHexadecimal:0x4b96ffff];
    UIColor *cornerColor = [UIColor colorWithHexadecimal:0xaaaaaaff];
    if (self.indexOfUnreadList <= 0) {
        [self.previousButton setTitleColor:cornerColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:defaultColor forState:UIControlStateNormal];
    }
    else if (self.indexOfUnreadList >= [self.unreadList count]-1) {
        [self.previousButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:cornerColor forState:UIControlStateNormal];
    }
    else {
        [self.previousButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:defaultColor forState:UIControlStateNormal];
    }
}

/**
 * 外部リンクを押して、Webを開くときの挙動
 * @param URL URL
 */
- (void)openURL:(NSURL *)URL
{
    // URL
    self.openingURL = URL;
    // 遷移
    [self performSegueWithIdentifier:kStoryboardSeguePushWebViewController
                              sender:self];
}


@end
