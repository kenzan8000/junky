#import "JBRSSFeedUnreadController.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBWebViewController.h"
#import "JBSidebarMenu.h"
/// Connection
#import "StatusCode.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "IonIcons.h"


#pragma mark - JBRSSFeedUnreadController
@implementation JBRSSFeedUnreadController


#pragma mark - synthesize
@synthesize unreadList;
@synthesize indexOfUnreadList;
@synthesize titleView;
@synthesize nextFeedButton;
@synthesize previousButton;
@synthesize nextButton;
@synthesize backButtonView;
@synthesize menuButtonView;
@synthesize sidebarMenu;


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
    self.sidebarMenu = nil;
    self.titleView = nil;
    self.backButtonView = nil;
    self.menuButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ナビゲーションバー
        // タイトル
    self.titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    self.titleView.delegate = self;
    [self.titleView useButton];
    self.navigationItem.titleView = self.titleView;
        // 戻る
    self.backButtonView = [UINib UIKitFromClassName:NSStringFromClass([JBBarButtonView class])];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];
        // メニューボタン
    self.menuButtonView = [UINib UIKitFromClassName:NSStringFromClass([JBBarButtonView class])];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.menuButtonView]]
                                       animated:NO];
    NSArray *buttonViews = @[self.backButtonView, self.menuButtonView];
    NSArray *buttonTitles = @[icon_chevron_left, icon_navicon_round];
    for (NSInteger i = 0; i < buttonViews.count; i++) {
        [buttonViews[i] setDelegate:self];
        [buttonViews[i] setTitle:buttonTitles[i]];
        [self.menuButtonView setFont:[IonIcons fontWithSize:20]];
    }
    self.sidebarMenu = [[JBSidebarMenu alloc] initWithSidebarType:JBSidebarMenuTypeDefault];

    // WebView読み込み
    [self loadWebView];

    // 画面下のバーのレイアウト
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
            break;
        default:
            break;
    }
}


#pragma mark - JBNavigationBarTitleViewDelegate
/**
 * タイトルボタン押下
 * @param titleView titleView
 */
- (void)touchedUpInsideTitleButtonWithNavigationBarTitleViewDelegate:(JBNavigationBarTitleView *)titleView
{
    JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
    if (unread) {
        [self openURL:unread.link];
    }
}


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    // ログイン
    if (barButtonView == self.backButtonView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // メニュー
    else if (barButtonView == self.menuButtonView) {
        JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
        if (unread) {
            [self.sidebarMenu setWebTitle:unread.title];
            [self.sidebarMenu setWebURL:unread.link];
        }
        [self.sidebarMenu show];
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
        [self.titleView setTitle:unread.title];
        [self.webView loadHTMLString:unread.body
                             baseURL:unread.link];
    }
}


#pragma mark - private api
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
    // 遷移
    JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                    bundle:nil];
    [vc setInitialURL:URL];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


@end
