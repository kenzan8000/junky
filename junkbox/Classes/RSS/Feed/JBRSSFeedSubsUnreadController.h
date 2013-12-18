#import "TableViewController.h"
#import "JBRSSFeedSubsUnreadList.h"


#pragma mark - JBRSSFeedSubsUnreadController
/// RSSフィード未読一覧
@interface JBRSSFeedSubsUnreadController : TableViewController <JBRSSFeedSubsUnreadListDelegate> {
}


#pragma mark - property
/// 未読一覧
@property (nonatomic, strong) JBRSSFeedSubsUnreadList *unreadList;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


#pragma mark - api


@end
