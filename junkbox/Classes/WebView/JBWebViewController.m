#import "JBWebViewController.h"
#import "JBNavigationBarTitleView.h"
// UIKit-Extension
#import "UIBarButtonItem+Space.h"
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"
// Pods
#import "IonIcons.h"
#import "JBHTBBookmarkViewController.h"


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
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(webViewProgressDidFinished)
                                               object:nil];

    [self.webView setDelegate:nil];
    [self.webViewProgress setWebViewProxyDelegate:nil];
    [self.webViewProgress setProgressDelegate:nil];

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

    // WebView
    [self.webView setScalesPageToFit:YES];

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
    self.backButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:nil/*NSLocalizedString(@"Back", @"戻る")*/
                                                                   icon:icon_arrow_left_a];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];
        // メニューボタン
    self.menuButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:nil/*NSLocalizedString(@"Menu", @"メニューボタン")*/
                                                                   icon:icon_navicon_round];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.menuButtonView]]
                                       animated:NO];
        // メニュー
    self.sidebarMenu = [[JBSidebarMenu alloc] initWithSidebarType:JBSidebarMenuTypeDefault];
    [self.sidebarMenu setDelegate:self];

    [self.sidebarMenu setWebURL:self.initialURL];
    [self.sidebarMenu setWebTitle:[self.initialURL absoluteString]];

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
        [self performSelector:@selector(webViewProgressDidFinished)
                   withObject:nil
                   afterDelay:1.0f];
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
        [self.sidebarMenu setWebTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
        [self.sidebarMenu show];
    }
}


#pragma mark - JBSidebarMenuDelegate
/**
 * Bookmarkの編集画面へ遷移
 * @param sidebarMenu JBSidebarMenu
 * @param URL BookmarkするページのURL
 */
- (void)bookmarkWillStartWithSidebarMenu:(JBSidebarMenu *)sidebarMenu
                                     URL:(NSURL *)URL
{
    JBHTBBookmarkViewController *vc = [JBHTBBookmarkViewController new];
    [vc setURL:URL];
    [self presentViewController:vc
                       animated:YES
                     completion:^ () {}];
}


#pragma mark - event listener


#pragma mark - api


#pragma mark - private api
/**
 * WebView読み込み完了
 */
- (void)webViewProgressDidFinished
{
    [self performSelectorOnMainThread:@selector(progressDidFinished)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)progressDidFinished
{
    [self.webViewProgressView setProgress:0
                                 animated:NO];
}


@end
