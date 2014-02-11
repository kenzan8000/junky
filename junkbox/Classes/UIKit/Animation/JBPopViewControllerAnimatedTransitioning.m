#import "JBPopViewControllerAnimatedTransitioning.h"


#pragma mark - JBPopViewControllerAnimatedTransitioning
@implementation JBPopViewControllerAnimatedTransitioning


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

    UIView *toView = [toVC view];

    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    toFrame.origin.x -= CGRectGetWidth(toFrame);
    toView.frame = toFrame;
    toFrame = [transitionContext finalFrameForViewController:toVC];

    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromVC.view];

    endFrame.origin.x += CGRectGetWidth(endFrame);

    toView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    toView.frame = toFrame;
    toView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        toView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        fromVC.view.frame = endFrame;
    }
                     completion:^ (BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
