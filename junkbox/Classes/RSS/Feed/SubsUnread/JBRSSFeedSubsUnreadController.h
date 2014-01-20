#import "TableViewController.h"
#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedUnreadLists.h"
#import "JBBarButtonView.h"


#pragma mark - JBRSSFeedSubsUnreadController
/// RSSフィード未読一覧
@interface JBRSSFeedSubsUnreadController : TableViewController <JBRSSFeedSubsUnreadListDelegate, JBRSSFeedUnreadListsDelegate, JBBarButtonViewDelegate> {
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
/// メニューボタン
@property (nonatomic, strong) JBBarButtonView *menuButtonView;


#pragma mark - api


@end
