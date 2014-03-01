#import "JBBarButtonView.h"
// Pods
#import "HTBLoginWebViewController.h"


#pragma mark - class
@class TYMActivityIndicatorView;


#pragma mark - JBBookmarkLoginController
/// ブックマークログインViewController
@interface JBBookmarkLoginController : HTBLoginWebViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// 閉じるボタン
@property (nonatomic, strong) JBBarButtonView *closeButton;
/// インジケーター
@property (nonatomic, strong) TYMActivityIndicatorView *indicatorView;


#pragma mark - event listener


@end
