#import "TableViewController.h"
#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedUnreadLists.h"


#pragma mark - class
@class JBRSSLoginOperations;


#pragma mark - JBRSSFeedSubsUnreadController
/// RSSフィード未読一覧
@interface JBRSSFeedSubsUnreadController : TableViewController <JBRSSFeedSubsUnreadListDelegate, JBRSSFeedUnreadListsDelegate> {
}


#pragma mark - property
/// 未読一覧
@property (nonatomic, strong) JBRSSFeedSubsUnreadList *subsUnreadList;
/// 詳細一覧
@property (nonatomic, strong) JBRSSFeedUnreadLists *unreadLists;
/// 選択中のセル
@property (nonatomic, assign) NSInteger indexOfselectCell;

/// 再認証処理
@property (nonatomic, strong) JBRSSLoginOperations *loginOperation;


#pragma mark - event listener
/**
 * ログインボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button;


#pragma mark - api


@end
