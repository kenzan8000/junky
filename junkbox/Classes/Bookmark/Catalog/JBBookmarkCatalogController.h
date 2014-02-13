#import "TableViewController.h"
#import "JBBarButtonView.h"
#import "JBBookmarkList.h"


#pragma mark - JBBookmarkCatalogController
/// ブックマーク一覧
@interface JBBookmarkCatalogController : TableViewController <JBBarButtonViewDelegate, JBBookmarkListDelegate> {
}


#pragma mark - property
/// ログインボタン
@property (nonatomic, strong) JBBarButtonView *loginButtonView;
/// 検索ボタン
@property (nonatomic, strong) JBBarButtonView *searchButtonView;
/// ログインModal
@property (nonatomic, strong) UINavigationController *loginModalViewController;

/// Bookmark一覧
@property (nonatomic, strong) JBBookmarkList *bookmarkList;


#pragma mark - event listener


@end
