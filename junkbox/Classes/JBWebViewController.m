#import "JBWebViewController.h"
// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"


#pragma mark - JBWebViewController
@implementation JBWebViewController


#pragma mark - synthesize
@synthesize webViewProgressView;
@synthesize initialURL;
@synthesize webViewProgress;


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
