#pragma mark - constant
/// presentアニメーション時間
#define kJBPopupViewCotrollerPresentTime 0.25f
/// dimissアニメーション時間
#define kJBPopupViewCotrollerDismissTime 0.15f


#pragma mark - JBPopupViewControllerManager
/// Popup UIの管理用
@interface JBPopupViewControllerManager : NSObject {
}


#pragma mark - property
/// 管理しているViewController
@property (nonatomic, strong) NSMutableArray *viewControllers;


#pragma mark - class method
+ (JBPopupViewControllerManager *)sharedInstance;


#pragma mark - api
/**
 * popup viewController
 * @param viewController 表示するviewController
 */
- (void)presentViewController:(UIViewController *)viewController;

/**
 * dismiss viewcontroller
 * @param viewController 消すviewController
 */
- (void)dismissViewController:(UIViewController *)viewController;


@end



#pragma mark - JBPopupViewController
/// ポップアップUI
@interface JBPopupViewController : UIViewController {
}


#pragma mark - api
/**
 * 表示
 */
- (void)presentPopup;

/**
 * 非表示
 */
- (void)dismissPopup;


@end
