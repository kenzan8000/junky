#import "JBBarButtonView.h"
// Pods
#import "HTBLoginWebViewController.h"


#pragma mark - JBBookmarkLoginController
/// ブックマークログインViewController
@interface JBBookmarkLoginController : HTBLoginWebViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// 閉じるボタン
@property (nonatomic, strong) JBBarButtonView *closeButton;


#pragma mark - event listener


@end
