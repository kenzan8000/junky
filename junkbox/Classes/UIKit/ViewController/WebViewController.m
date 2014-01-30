#import "WebViewController.h"


#pragma mark - WebViewController
@implementation WebViewController


#pragma mark - synthesize
@synthesize webView;
@synthesize refreshControl;


#pragma mark - release
- (void)dealloc
{
    [self.refreshControl removeFromSuperview];
    self.refreshControl = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // スクロール速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

    // Pull to Refresh
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(srcollViewDidPulled)
                  forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:self.refreshControl];
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.refreshControl endRefreshing];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [self.webView.scrollView setContentSize:CGSizeMake(self.webView.frame.size.width, self.webView.scrollView.contentSize.height)];
    [self.refreshControl endRefreshing];
}


#pragma mark - event listener
- (void)srcollViewDidPulled
{
    [self.webView reload];
}


@end
