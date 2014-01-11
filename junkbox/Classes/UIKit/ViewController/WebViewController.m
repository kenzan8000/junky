#import "WebViewController.h"
// NSFoundation-Extension
#import "NSURLRequest+Junkbox.h"


#pragma mark - WebViewController
@implementation WebViewController


#pragma mark - synthesize
@synthesize webView;


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // スクロール速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

    //[self.webView loadRequest:[NSMutableURLRequest JBRequestWithURL:URL]];
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
    [self.webView.scrollView setContentSize:CGSizeMake(self.webView.frame.size.width, self.webView.scrollView.contentSize.height)];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [self.webView.scrollView setContentSize:CGSizeMake(self.webView.frame.size.width, self.webView.scrollView.contentSize.height)];
}


@end
