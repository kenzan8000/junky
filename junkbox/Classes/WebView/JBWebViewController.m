#import "JBWebViewController.h"
#import "JBNavigationBarTitleView.h"
#import "JBSidebarMenu.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBWebViewController
@implementation JBWebViewController


#pragma mark - synthesize
@synthesize webViewProgressView;
@synthesize titleView;
@synthesize backButtonView;
@synthesize menuButtonView;
@synthesize sidebarMenu;
@synthesize webViewProgress;
@synthesize initialURL;


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
    self.initialURL = nil;
    self.sidebarMenu = nil;
    self.titleView = nil;
    self.backButtonView = nil;
    self.menuButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webViewProgressDidFinishedWithNotification:)
                                                 name:kNotificationWebViewProgressDidFinished
                                               object:nil];

    // プログレス
    self.webViewProgress = [NJKWebViewProgress new];
    [self.webView setDelegate:self.webViewProgress];
    [self.webViewProgress setWebViewProxyDelegate:self];
    [self.webViewProgress setProgressDelegate:self];
    CGFloat paddingY = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    [self.webViewProgressView setFrame:
        CGRectMake(
            self.webViewProgressView.frame.origin.x, paddingY,
            self.webViewProgressView.frame.size.width, self.webViewProgressView.frame.size.height
        )
    ];

    // ナビゲーションバー
        // タイトル
    self.titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [self.titleView setTitle:[self.initialURL absoluteString]];
    self.navigationItem.titleView = self.titleView;
        // 戻るボタン
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
        [buttonViews[i] setFont:[IonIcons fontWithSize:20]];
    }
        // メニュー
    self.sidebarMenu = [[JBSidebarMenu alloc] initWithSidebarType:JBSidebarMenuTypeDefault];
    [self.sidebarMenu setOpeningURL:self.initialURL];

    // 読み込み
    [self.webView loadRequest:[NSMutableURLRequest JBRequestWithURL:self.initialURL]];
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

    // リンクをクリック
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                        bundle:nil];
        [vc setInitialURL:request.URL];
        [self.navigationController pushViewController:vc
                                             animated:YES];
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

    // タイトル
    [self.titleView setTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [super webView:self.webView
didFailLoadWithError:error];
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress
{
    // 表示
    if (progress > self.webViewProgressView.progress) {
        [self.webViewProgressView setProgress:progress
                                     animated:NO];
    }

    // 読み込み完了
    NSInteger percent = 100 * (NSInteger)floor(progress);
    if (percent == 100) {
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2), dispatch_get_current_queue(), ^ () {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWebViewProgressDidFinished
                                                                object:nil
                                                              userInfo:@{@"initialURL":weakSelf.initialURL}];
        });
    }
}


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    if (barButtonView == self.backButtonView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (barButtonView == self.menuButtonView) {
        [self.sidebarMenu show];
    }
}


#pragma mark - notification
/**
 * WebView読み込みプログレス完了
 * @param notification notification
 */
- (void)webViewProgressDidFinishedWithNotification:(NSNotification *)notification
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.initialURL == [[notification userInfo] objectForKey:@"initialURL"]) {
            [weakSelf.webViewProgressView setProgress:0
                                             animated:NO];
        }
    });
}


#pragma mark - event listener


#pragma mark - api


#pragma mark - private api


@end
