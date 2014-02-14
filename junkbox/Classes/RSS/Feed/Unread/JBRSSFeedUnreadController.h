#import "WebViewController.h"
#import "JBRSSFeedUnreadList.h"
#import "JBNavigationBarTitleView.h"
#import "JBBarButtonView.h"


#pragma mark - class
@class JBNavigationBarTitleView;


#pragma mark - JBRSSFeedUnreadController
/// RSSフィード詳細
@interface JBRSSFeedUnreadController : WebViewController <JBRSSFeedUnreadListDelegate, JBNavigationBarTitleViewDelegate, JBBarButtonViewDelegate> {
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
/// 今見ているリストindex分子
@property (nonatomic, weak) IBOutlet UILabel *numeratorOfUnreadListLabel;
/// 今見ているリストindex分母
@property (nonatomic, weak) IBOutlet UILabel *denominatorOfUnreadListLabel;
/// 今見ているリストindexセパレータ
@property (nonatomic, weak) IBOutlet UILabel *separatorOfUnreadListLabel;
/// 前の記事へ
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
/// 次の記事へ
@property (nonatomic, weak) IBOutlet UIButton *nextButton;


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


#pragma mark - api
/**
 * 今見ているリストindexのWebViewを表示
 */
- (void)loadWebView;


@end
