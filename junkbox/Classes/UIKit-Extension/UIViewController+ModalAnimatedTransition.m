#import "UIViewController+ModalAnimatedTransition.h"


#pragma mark - UIViewController+ModalAnimatedTransition
@implementation UIViewController (ModalAnimatedTransition)


#pragma mark - notification
- (void)JBModalViewControllerWillDismissWithNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationModalViewControllerWillDismiss
                                                  object:nil];
    [self dismissJBAnimation];
}


#pragma mark - api
- (void)presentViewController:(UIViewController *)viewController
                   JBAnimated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    if (animated) {
        [self presentJBAnimation];
    }

    [self presentViewController:viewController
                       animated:animated
                     completion:completion];
}

- (void)dismissViewControllerJBAnimated:(BOOL)animated
                             completion:(void (^)(void))completion
{
    if (animated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModalViewControllerWillDismiss
                                                            object:nil
                                                          userInfo:@{}];
    }

    [self dismissViewControllerAnimated:animated
                             completion:completion];
}


#pragma mark - private api
/**
 * present animation
 */
- (void)presentJBAnimation
{
    UIViewController *vc = (self.navigationController) ? self.navigationController : self;

    // dismiss通知
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(JBModalViewControllerWillDismissWithNotification:)
                                                 name:kNotificationModalViewControllerWillDismiss
                                               object:nil];

    // 初期
    vc.view.transform = CGAffineTransformIdentity;
    vc.view.alpha = 1.0f;

    // アニメーション後
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        vc.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.95f, 0.95f), CGAffineTransformMakeTranslation(0.0f, 16.0f));
        vc.view.alpha = 0.5f;
    }
                     completion:^ (BOOL finished) {
    }];
}

/**
 * dismiss animation
 */
- (void)dismissJBAnimation
{
    UIViewController *vc = (self.navigationController) ? self.navigationController : self;

    // 初期
    vc.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.95f, 0.95f), CGAffineTransformMakeTranslation(0.0f, 16.0f));
    vc.view.alpha = 0.5f;

    // アニメーション後
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        vc.view.transform = CGAffineTransformIdentity;
        vc.view.alpha = 1.0f;
    }
                     completion:^ (BOOL finished) {
    }];
}


@end
