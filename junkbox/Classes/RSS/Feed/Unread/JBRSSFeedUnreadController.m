#import "JBRSSFeedUnreadController.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSPinList.h"
#import "JBWebViewController.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
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
@synthesize pinButtonView;


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
    self.titleView = nil;
    self.backButtonView = nil;
    self.pinButtonView = nil;
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
    self.backButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:NSLocalizedString(@"Back", @"戻る")
                                                                   icon:icon_chevron_left];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];
        // PINボタン
    self.pinButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                 title:@""//NSLocalizedString(@"Read Later", @"あとで読む")
                                                                  icon:icon_pin
                                                                 color:[UIColor colorWithHexadecimal:0xe04080ff]];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.pinButtonView]]
                                       animated:NO];
    [self.pinButtonView setBadgeText:[@([[JBRSSPinList sharedInstance] count]) stringValue]
                               color:[UIColor colorWithHexadecimal:0xaaaaaaff]];

    // ツールバー
    NSArray *buttons = @[self.nextFeedButton, self.previousButton, self.nextButton];
    NSArray *buttonTitles = @[icon_chevron_down, icon_chevron_left, icon_chevron_right];
    for (NSInteger i = 0; i < buttons.count; i++) {
        [buttons[i] setFont:[IonIcons fontWithSize:20]];
        [buttons[i] setTitle:buttonTitles[i]
                    forState:UIControlStateNormal];
    }

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
    // PIN
    else if (barButtonView == self.pinButtonView) {
        JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
        if (unread == nil) { return; }
        [[JBRSSPinList sharedInstance] addPinWithTitle:unread.title
                                                  link:[unread.link absoluteString]];
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.2), dispatch_get_main_queue(), ^ () {
            [weakSelf.pinButtonView setBadgeText:[@([[JBRSSPinList sharedInstance] count]) stringValue]
                                           color:[UIColor colorWithHexadecimal:0xaaaaaaff]];
        });
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
        [self.nextButton setTitleColor:(([self.unreadList count] <= 1) ? cornerColor : defaultColor) forState:UIControlStateNormal];
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
