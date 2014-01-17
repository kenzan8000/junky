#import "WebViewController.h"
#import "JBRSSFeedUnreadList.h"
#import "JBNavigationBarTitleView.h"


#pragma mark - class
@class JBRSSLoginOperations;
@class JBNavigationBarTitleView;


#pragma mark - JBRSSFeedUnreadController
/// RSSフィード詳細
@interface JBRSSFeedUnreadController : WebViewController <JBRSSFeedUnreadListDelegate, JBNavigationBarTitleViewDelegate> {
}


#pragma mark - property
/// RSSフィード詳細リスト
@property (nonatomic, strong) JBRSSFeedUnreadList *unreadList;
/// 今見ているリストindex
@property (nonatomic, assign) NSInteger indexOfUnreadList;

/// ナビゲーションバータイトル
@property (nonatomic, strong) JBNavigationBarTitleView *titleView;
/// 次のフィードへボタン
@property (nonatomic, weak) IBOutlet UIButton *nextFeedButton;
/// 前の記事へ
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
/// 次の記事へ
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

/// 再認証処理
@property (nonatomic, strong) JBRSSLoginOperations *loginOperation;


#pragma mark - event listener
/**
 * 次のフィードへボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithNextFeedButton:(UIButton *)button;

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


#pragma mark - api
/**
 * 今見ているリストindexのWebViewを表示
 */
- (void)loadWebView;


@end
