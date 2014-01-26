#import "TableViewController.h"
#import "JBBarButtonView.h"


#pragma mark - JBBookmarkCatalogController
/// ブックマーク一覧
@interface JBBookmarkCatalogController : TableViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
@property (nonatomic, strong) JBBarButtonView *loginButtonView;


#pragma mark - event listener


@end
