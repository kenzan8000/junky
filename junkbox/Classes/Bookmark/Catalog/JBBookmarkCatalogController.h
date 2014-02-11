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

/// ログインModal
@property (nonatomic, strong) UINavigationController *loginModalViewController;
/// ログインModalCloseButton
@property (nonatomic, strong) JBBarButtonView *modalCloseButtonView;

/// Bookmark一覧
@property (nonatomic, strong) JBBookmarkList *bookmarkList;


#pragma mark - event listener


@end
