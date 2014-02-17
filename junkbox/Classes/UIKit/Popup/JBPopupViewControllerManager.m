#import "JBPopupViewControllerManager.h"


#pragma mark - JBPopupViewControllerManager
@implementation JBPopupViewControllerManager


#pragma mark - property
@synthesize viewControllers;


#pragma mark - class method
+ (JBPopupViewControllerManager *)sharedInstance
{
    static dispatch_once_t onceToken = NULL;
    static JBPopupViewControllerManager *_JBPopupViewControllerManager = nil;
    dispatch_once(&onceToken, ^ () {
        _JBPopupViewControllerManager = [JBPopupViewControllerManager new];
    });
    return _JBPopupViewControllerManager;
}


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.viewControllers = [NSMutableArray arrayWithArray:@[]];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.viewControllers = nil;
}


#pragma mark - api
- (void)presentViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[JBPopupViewController class]] == NO) { return ;}

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if ([weakSelf.viewControllers containsObject:viewController]) { return; }

        [weakSelf.viewControllers addObject:viewController];
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:viewController.view];
        [viewController.view setFrame:CGRectMake(
            0, 0, window.frame.size.width, window.frame.size.height
        )];
        [(JBPopupViewController *)viewController animatePresent];
    });
}

- (void)dismissViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[JBPopupViewController class]] == NO) { return ;}

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if ([weakSelf.viewControllers containsObject:viewController] == NO) { return; }
        [(JBPopupViewController *)viewController dismissPopup];
    });
}


#pragma mark - private api
/**
 * viewControllerをdealloc
 * @param viewController deallocするviewController
 */
- (void)removeViewController:(UIViewController *)viewController
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if ([weakSelf.viewControllers containsObject:viewController] == NO) { return; }
        [viewController.view removeFromSuperview];
        [weakSelf.viewControllers removeObject:viewController];
    });
}


@end



#pragma mark - JBPopupViewController
@implementation JBPopupViewController


#pragma mark - synthesize
@synthesize animated;


#pragma mark - api
- (void)presentPopup
{
    [self presentPopupAnimated:YES];
}

- (void)presentPopupAnimated:(BOOL)a
{
    self.animated = a;
    [[JBPopupViewControllerManager sharedInstance] presentViewController:self];
}

- (void)dismissPopup
{
    [self animateDismiss];
}

- (void)animatePresent
{
    if (self.animated) {
        self.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        self.view.alpha = 0.0f;

        // アニメーション
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:kJBPopupViewCotrollerPresentTime
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ () {
            weakSelf.view.transform = CGAffineTransformIdentity;
            weakSelf.view.alpha = 1.0f;
        }
                         completion:^ (BOOL finished) {
        }];
    }
}

- (void)animateDismiss
{
    if (self.animated) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.alpha = 1.0f;

        // アニメーション
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:kJBPopupViewCotrollerDismissTime
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ () {
            weakSelf.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            weakSelf.view.alpha = 0.0f;
        }
                         completion:^ (BOOL finished) {
            [[JBPopupViewControllerManager sharedInstance] removeViewController:weakSelf];
        }];
    }
    else {
        [[JBPopupViewControllerManager sharedInstance] removeViewController:self];
    }
}


@end;
