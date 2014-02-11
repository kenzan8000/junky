#import "TableViewController.h"
#import "JBBarButtonView.h"


#pragma mark - JBBookmarkCatalogController
/// ブックマーク一覧
@interface JBBookmarkCatalogController : TableViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// ログインボタン
@property (nonatomic, strong) JBBarButtonView *loginButtonView;

/// ログインModal
@property (nonatomic, strong) UINavigationController *loginModalViewController;
/// ログインModalCloseButton
@property (nonatomic, strong) JBBarButtonView *modalCloseButtonView;


#pragma mark - event listener


@end
