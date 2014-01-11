#import "JBRSSFeedUnreadController.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSLoginOperations.h"
#import "JBRSSOperationQueue.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "MTStatusBarOverlay.h"


#pragma mark - JBRSSFeedUnreadController
@implementation JBRSSFeedUnreadController


#pragma mark - synthesize
@synthesize unreadList;
@synthesize indexOfUnreadList;
@synthesize nextFeedButton;
@synthesize loginOperation;


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
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    [self loadWebView];
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


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:self.webView
shouldStartLoadWithRequest:request
    navigationType:navigationType];
/*
    NSInteger type = (NSInteger)navigationType;
    switch (type) {
        case UIWebViewNavigationTypeLinkClicked:
            break;
    }
*/
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
}

- (IBAction)touchedUpInsideWithNextButton:(UIButton *)button
{
    self.indexOfUnreadList++;
    if (self.indexOfUnreadList >= [self.unreadList count]) { self.indexOfUnreadList = [self.unreadList count]-1; }
    else { [self loadWebView]; }
}


#pragma mark - api
- (void)loadWebView
{
    JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
    if (unread) {
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


@end
