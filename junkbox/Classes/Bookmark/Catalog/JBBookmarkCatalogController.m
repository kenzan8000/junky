#import "JBBookmarkCatalogController.h"
#import "JBNavigationBarTitleView.h"
#import "JBBookmarkCatalogTableViewCell.h"
#import "JBBookmarkLoginController.h"
#import "JBBookmark.h"
/// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIViewController+ModalAnimatedTransition.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "HatenaBookmarkSDK.h"
#import "IonIcons.h"


#pragma mark - JBBookmarkCatalogController
@implementation JBBookmarkCatalogController


#pragma mark - synthesize
@synthesize loginButtonView;
@synthesize searchButtonView;
@synthesize loginModalViewController;
@synthesize bookmarkList;


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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationModalBookmarkLoginControllerWillDismiss
                                                  object:nil];
    self.loginButtonView = nil;
    self.searchButtonView = nil;
    self.loginModalViewController = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissLoginModalViewCntrollerWithNotification:)
                                                 name:kNotificationModalBookmarkLoginControllerWillDismiss
                                               object:nil];
    // Hatebu
    self.bookmarkList = [JBBookmarkList sharedInstance];
    [self.bookmarkList setDelegate:self];
    [self.bookmarkList loadFromLocal];
    if ([HTBHatenaBookmarkManager sharedManager].authorized) {
    }

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Bookmark", @"はてブ一覧")];
    self.navigationItem.titleView = titleView;
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:nil/*icon_log_in*/];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
                                      animated:NO];
        // 検索ボタン
    self.searchButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                    title:nil
                                                                     icon:icon_ios7_search_strong];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.searchButtonView]]
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
    return self.bookmarkList.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBBookmark *bookmark = (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
    return ([bookmark.summary isEqualToString:@""]) ?
        kJBBookmarkCatalogTableViewCellHeight - kJBBookmarkCatalogTableViewCellLabelHeight : kJBBookmarkCatalogTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBBookmarkCatalogTableViewCell class]);
    JBBookmarkCatalogTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];

        JBBookmark *bookmark = (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
        if (bookmark) {
            [cell designWithBookmark:bookmark];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
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
        // Login
        [[HTBHatenaBookmarkManager sharedManager] logout];
        __weak __typeof(self) weakSelf = self;
        [[HTBHatenaBookmarkManager sharedManager] authorizeWithSuccess:^ () {
            // Statusbar
            [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Getting the bookmark list...", @"ブックマーク一覧取得")
                                                    animated:YES];
            // Bookmark一覧インポート
            [weakSelf.bookmarkList loadFromWebAPI];
            // dismiss
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModalBookmarkLoginControllerWillDismiss
                                                                object:nil
                                                              userInfo:@{}];
        }
                                                               failure:^ (NSError *error) {
        }];
    }
}


#pragma mark - JBBookmarkListDelegate
/**
 * Bookmark一覧取得成功
 * @param list 一覧
 */
- (void)bookmarkListDidFinishLoadWithList:(JBBookmarkList *)list
{
    [self.refreshControl endRefreshing];
    // ステータスバー
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^ () {
        [[MTStatusBarOverlay sharedInstance] hide];
    });
    [self.tableView reloadData];
}

/**
 * Bookmark一覧取得失敗
 * @param error error
 */
- (void)bookmarkListDidFailLoadWithError:(NSError *)error
{
    [[MTStatusBarOverlay sharedInstance] hide];
}


#pragma mark - notification
/**
 * HatenaBookmarkのログインModal表示用通知
 * @param notification Notification
 */
- (void)showOAuthLoginViewWithNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kHTBLoginStartNotification
                                                  object:nil];

    self.loginModalViewController = [UINavigationController new];
    JBBookmarkLoginController *vc = [[JBBookmarkLoginController alloc] initWithAuthorizationRequest:(NSURLRequest *)notification.object];
    self.loginModalViewController.viewControllers = @[vc];
    [self presentViewController:self.loginModalViewController
                     JBAnimated:YES
                     completion:nil];
}

/**
 * HatenaBookmarkのログインModal Dismiss通知
 * @param notification Notification
 */
- (void)dismissLoginModalViewCntrollerWithNotification:(NSNotification *)notification
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        [weakSelf.loginModalViewController dismissViewControllerJBAnimated:YES
                                                                completion:^ () {
            if (weakSelf.loginModalViewController) {
                weakSelf.loginModalViewController = nil;
            }
        }];
    });
}


#pragma mark - event listener


#pragma mark - private api


@end
