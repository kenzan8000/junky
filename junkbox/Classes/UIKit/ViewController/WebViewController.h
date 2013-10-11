#pragma mark - WebViewController
/// WebViewを表示する
@interface WebViewController : UIViewController <UIWebViewDelegate> {
}


#pragma mark - property
/// WebView
@property (nonatomic, weak) IBOutlet UIWebView *webView;


@end
