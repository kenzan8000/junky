#import "TableViewController.h"
#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedUnreadLists.h"
#import "JBBarButtonView.h"
#import "JBRSSFeedUnreadController.h"


#pragma mark - JBRSSFeedSubsUnreadController
/// RSSフィード未読一覧
@interface JBRSSFeedSubsUnreadController : TableViewController <JBRSSFeedSubsUnreadListDelegate, JBRSSFeedUnreadListsDelegate, JBBarButtonViewDelegate, JBRSSFeedUnreadControllerDelegate> {
}


#pragma mark - property
/// 未読一覧
@property (nonatomic, strong) JBRSSFeedSubsUnreadList *subsUnreadList;
/// 詳細一覧
@property (nonatomic, strong) JBRSSFeedUnreadLists *unreadLists;
/// 選択中のセル
@property (nonatomic, assign) NSInteger indexOfselectCell;
/// ログインボタン
@property (nonatomic, strong) JBBarButtonView *loginButtonView;


#pragma mark - api


@end
