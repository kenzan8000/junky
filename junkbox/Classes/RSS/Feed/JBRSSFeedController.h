#import "TableViewController.h"


#pragma mark - JBRSSFeedController
/// RSSフィード詳細
@interface JBRSSFeedController : TableViewController {
}


#pragma mark - property
/// ログインボタン
@property (nonatomic, strong) UIButton *loginButton;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


#pragma mark - api
/**
 * 未読一覧フィードをロードする
 */
- (void)loadFeed;


@end
