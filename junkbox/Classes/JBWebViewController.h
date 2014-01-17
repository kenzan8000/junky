#import "WebViewController.h"
/// Pods
#import "NJKWebViewProgress.h"


#pragma mark - JBWebViewController
/// 共通のWebView
@interface JBWebViewController : WebViewController <NJKWebViewProgressDelegate> {
}


#pragma mark - property
/// WebView読み込みプログレスバー
@property (nonatomic, weak) IBOutlet UIProgressView *webViewProgressView;
/// 初期URL
@property (nonatomic, strong) NSURL *initialURL;
/// WebView読み込みプログレス
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;


#pragma mark - event listener


#pragma mark - api


@end
