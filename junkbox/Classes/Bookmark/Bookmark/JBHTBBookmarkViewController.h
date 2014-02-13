#import "HTBBookmarkViewController.h"
// Pods
#import "JBBarButtonView.h"


#pragma mark - JBHTBBookmarkViewController
/// ブックマーク
@interface JBHTBBookmarkViewController : HTBBookmarkViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// 閉じるボタン
@property (nonatomic, strong) JBBarButtonView *closeButton;


@end
