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
/// 検索バー
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
/// ログインModal
@property (nonatomic, strong) UINavigationController *loginModalViewController;

/// Bookmark一覧
@property (nonatomic, strong) JBBookmarkList *bookmarkList;
/// Bookmark検索結果
@property (nonatomic, strong) NSMutableArray *searchedBookmarkList;


#pragma mark - event listener


@end
