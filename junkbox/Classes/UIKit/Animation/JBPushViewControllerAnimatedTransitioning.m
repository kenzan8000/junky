#import "JBPushViewControllerAnimatedTransitioning.h"


#pragma mark - JBPushViewControllerAnimatedTransitioning
@implementation JBPushViewControllerAnimatedTransitioning


#pragma mark - api
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect endFrame = [transitionContext initialFrameForViewController:fromVC];
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView addSubview:fromVC.view];

    fromVC.view.alpha = 1.0f;
    fromVC.view.transform = CGAffineTransformIdentity;
    toVC.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(endFrame), 0);

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        fromVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        fromVC.view.alpha = 0.5f;
        toVC.view.transform = CGAffineTransformMakeTranslation(endFrame.origin.x, 0);
    }
                     completion:^ (BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
