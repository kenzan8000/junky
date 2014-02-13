#import "JBBookmarkLoginController.h"
#import "JBNavigationBarTitleView.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBBookmarkLoginController
@implementation JBBookmarkLoginController


#pragma mark - synthesize
@synthesize closeButton;


#pragma mark - initializer


#pragma mark - release
- (void)dealloc
{
    self.closeButton = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // NavigationBar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexadecimal:0x4682b4ff];
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Hatena Bookmark", @"はてブ")];
    self.navigationItem.titleView = titleView;
        // 閉じるボタン
    self.closeButton = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                               title:nil
                                                                icon:icon_close_round];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.closeButton]]
                                      animated:NO];
        //
    JBBarButtonView *menuButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                              title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                               icon:icon_navicon_round];
    [menuButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:menuButtonView]]
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
    if ([super respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [super webView:webView
    shouldStartLoadWithRequest:request
               navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([super respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [super webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([super respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [super webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    if ([super respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [super webView:webView
  didFailLoadWithError:error];
    }
}


#pragma mark - event listener


#pragma mark - private api


@end
