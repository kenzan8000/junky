#import "WebViewController.h"
#import "JBRSSFeedUnreadList.h"
#import "JBNavigationBarTitleView.h"
#import "JBBarButtonView.h"


#pragma mark - class
@class JBNavigationBarTitleView;
@class JBQBFlatButton;


#pragma mark - JBRSSFeedUnreadController
/// RSSフィード詳細
@interface JBRSSFeedUnreadController : WebViewController <UIScrollViewDelegate, JBRSSFeedUnreadListDelegate, JBNavigationBarTitleViewDelegate, JBBarButtonViewDelegate> {
}


#pragma mark - property
/// RSSフィード詳細リスト
@property (nonatomic, strong) JBRSSFeedUnreadList *unreadList;
/// 今見ているリストindex
@property (nonatomic, assign) NSInteger indexOfUnreadList;

/// ナビゲーションバータイトル
@property (nonatomic, strong) JBNavigationBarTitleView *titleView;
/// ナビゲーションバー前の画面へ戻るボタン
@property (nonatomic, strong) JBBarButtonView *backButtonView;
/// ナビゲーションバーPINボタン
@property (nonatomic, strong) JBBarButtonView *pinButtonView;
/// 今見ているリストindex背景View
@property (nonatomic, weak) IBOutlet UIView *indexOfUnreadListBackgroundView;
/// 今見ているリストindex
@property (nonatomic, weak) IBOutlet UILabel *indexOfUnreadListLabel;
/// 今見ているページURL
@property (nonatomic, weak) IBOutlet UILabel *URLLabel;
/// 前の記事へ
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
/// 次の記事へ
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

/// 記事一覧読み込み失敗した時のためのリロードボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *reloadButton;


#pragma mark - event listener
/**
 * index前へボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithPreviousButton:(UIButton *)button;

/**
 * index次へボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithNextButton:(UIButton *)button;

/*
 * 記事一覧リロードボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithReloadButton:(UIButton *)button;


#pragma mark - api
/**
 * 今見ているリストindexのWebViewを表示
 */
- (void)loadWebView;


@end
