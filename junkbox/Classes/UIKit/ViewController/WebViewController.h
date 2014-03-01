#pragma mark - class
@class TYMActivityIndicatorView;


#pragma mark - WebViewController
/// WebViewを表示する
@interface WebViewController : UIViewController <UIWebViewDelegate> {
}


#pragma mark - property
/// WebView
@property (nonatomic, weak) IBOutlet UIWebView *webView;
/// Pull to Refresh
@property (nonatomic, strong) UIRefreshControl *refreshControl;
/// Webview Indicator
@property (nonatomic, weak) IBOutlet TYMActivityIndicatorView *indicatorView;

@end
