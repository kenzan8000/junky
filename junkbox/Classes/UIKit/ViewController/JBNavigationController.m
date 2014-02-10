#import "JBNavigationController.h"
#import "JBPushViewControllerAnimatedTransitioning.h"
#import "JBPopViewControllerAnimatedTransitioning.h"


#pragma mark - JBNavigationController
@implementation JBNavigationController


#pragma mark - synthesize


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    self.delegate = self;

    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        JBPushViewControllerAnimatedTransitioning *transitioning = [JBPushViewControllerAnimatedTransitioning new];
        return transitioning;
    }
    else if (operation == UINavigationControllerOperationPop) {
        JBPopViewControllerAnimatedTransitioning *transitioning = [JBPopViewControllerAnimatedTransitioning new];
        return transitioning;
    }
    return nil;
}


@end
