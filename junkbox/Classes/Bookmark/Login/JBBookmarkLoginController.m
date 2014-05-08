#import "JBBookmarkLoginController.h"
#import "JBNavigationBarTitleView.h"
// UIKit-Extension
#import "UIBarButtonItem+Space.h"
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
// Pods
#import "IonIcons.h"
#import "TYMActivityIndicatorView.h"


#pragma mark - JBBookmarkLoginController
@implementation JBBookmarkLoginController


#pragma mark - synthesize
@synthesize closeButton;
@synthesize indicatorView;


#pragma mark - initializer


#pragma mark - release
- (void)dealloc
{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    self.closeButton = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    self.indicatorView = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
    [self.indicatorView setBackgroundImage:nil];
    [self.indicatorView setHidesWhenStopped:YES];
    [self.indicatorView stopAnimating];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.center = self.view.center;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // NavigationBar
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexadecimal:0x4682b4ff];
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Hatena Bookmark", @"はてブ")];
    self.navigationItem.titleView = titleView;
        // 閉じるボタン
    self.closeButton = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                               title:nil
                                                                icon:icon_android_close];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.closeButton]]
                                      animated:NO];
        //
    JBBarButtonView *menuButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                              title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                               icon:icon_navicon];
    [menuButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:menuButtonView]]
                                       animated:NO];
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


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    if (barButtonView == self.closeButton) {
        // dismiss
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModalBookmarkLoginControllerWillDismiss
                                                            object:nil
                                                          userInfo:@{}];
    }
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([HTBLoginWebViewController instancesRespondToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [super webView:webView
   shouldStartLoadWithRequest:request
               navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([HTBLoginWebViewController instancesRespondToSelector:@selector(webViewDidStartLoad:)]) {
        [super webViewDidStartLoad:webView];
    }
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([HTBLoginWebViewController instancesRespondToSelector:@selector(webViewDidFinishLoad:)]) {
        [super webViewDidFinishLoad:webView];
    }
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    if ([HTBLoginWebViewController instancesRespondToSelector:@selector(webView:didFailLoadWithError:)]) {
        [super webView:webView
  didFailLoadWithError:error];
    }
    [self.indicatorView stopAnimating];
}


#pragma mark - event listener


#pragma mark - private api


@end
