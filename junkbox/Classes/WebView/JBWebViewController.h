#import "WebViewController.h"
#import "JBBarButtonView.h"
/// Pods
#import "NJKWebViewProgress.h"


#pragma mark - class
@class JBNavigationBarTitleView;
@class JBSidebarMenu;


#pragma mark - JBWebViewController
/// 共通のWebView
@interface JBWebViewController : WebViewController <NJKWebViewProgressDelegate, JBBarButtonViewDelegate> {
}


#pragma mark - property
/// WebView読み込みプログレスバー
@property (nonatomic, weak) IBOutlet UIProgressView *webViewProgressView;
/// ナビゲーションバータイトル
@property (nonatomic, strong) JBNavigationBarTitleView *titleView;
/// ナビゲーションバー戻るボタン
@property (nonatomic, strong) JBBarButtonView *backButtonView;
/// ナビゲーションバーメニューボタン
@property (nonatomic, strong) JBBarButtonView *menuButtonView;
/// メニュー
@property (nonatomic, strong) JBSidebarMenu *sidebarMenu;
/// WebView読み込みプログレス
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;
/// 初期URL
@property (nonatomic, strong) NSURL *initialURL;

#pragma mark - event listener


#pragma mark - api


@end
