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

    fromVC.view.frame = endFrame;
    [transitionContext.containerView addSubview:fromVC.view];

    UIView *toView = [toVC view];
    [transitionContext.containerView addSubview:toView];

    CGRect startFrame = toView.frame;
    endFrame = startFrame;

    startFrame.origin.x += CGRectGetWidth(startFrame);
    toView.frame = startFrame;

    UIView *fromView = [fromVC view];
    CGRect outgoingEndFrame = fromView.frame;
    outgoingEndFrame.origin.x -= CGRectGetWidth(outgoingEndFrame);

    fromView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    fromView.alpha = 1.0f;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        fromView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        fromView.alpha = 0.5f;
        toView.frame = endFrame;
    }
                    completion:^ (BOOL finished) {
        [toView setNeedsUpdateConstraints];
        [transitionContext completeTransition:YES];
    }];
}


@end
