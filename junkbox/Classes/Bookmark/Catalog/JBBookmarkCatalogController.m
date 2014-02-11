#import "JBBookmarkCatalogController.h"
/// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIViewController+ModalAnimatedTransition.h"
/// Pods
#import "HatenaBookmarkSDK.h"
#import "IonIcons.h"


#pragma mark - JBBookmarkCatalogController
@implementation JBBookmarkCatalogController


#pragma mark - synthesize
@synthesize loginButtonView;
@synthesize loginModalViewController;
@synthesize modalCloseButtonView;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.loginButtonView = nil;
    self.loginModalViewController = nil;
    self.modalCloseButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // Hatebu
    if ([HTBHatenaBookmarkManager sharedManager].authorized) {
    }

    // ナビゲーションバー
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:nil/*icon_log_in*/];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
                                      animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
//        cell = [UINib UIKitFromClassName:className];
    }
    return cell;
}


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    // ログイン
    if (barButtonView == self.loginButtonView) {
        // Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showOAuthLoginViewWithNotification:)
                                                     name:kHTBLoginStartNotification
                                                   object:nil];
        [[HTBHatenaBookmarkManager sharedManager] logout];
        __weak __typeof(self) weakSelf = self;
        [[HTBHatenaBookmarkManager sharedManager] authorizeWithSuccess:^ () {
            [weakSelf touchedUpInsideButtonWithBarButtonView:weakSelf.modalCloseButtonView];
        }
                                                               failure:^ (NSError *error) {

        }];
    }
    // ログインModal閉じる
    else if (barButtonView == self.modalCloseButtonView) {
        if (self.loginModalViewController == nil) { return; }

        __weak __typeof(self) weakSelf = self;
        [self.loginModalViewController dismissViewControllerJBAnimated:YES
                                                            completion:^ () {
            weakSelf.loginModalViewController = nil;
            weakSelf.modalCloseButtonView = nil;
        }];
    }
}


#pragma mark - notification
- (void)showOAuthLoginViewWithNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kHTBLoginStartNotification
                                                  object:nil];

    self.loginModalViewController = [UINavigationController new];
    HTBLoginWebViewController *vc = [[HTBLoginWebViewController alloc] initWithAuthorizationRequest:(NSURLRequest *)notification.object];
    self.modalCloseButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                        title:nil
                                                                         icon:icon_close_round];
    [vc.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.modalCloseButtonView]]
                                    animated:NO];
    self.loginModalViewController.viewControllers = @[vc];
    [self presentViewController:self.loginModalViewController
                     JBAnimated:YES
                     completion:nil];
}


#pragma mark - event listener


@end
