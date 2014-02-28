#import "JBBookmarkCatalogController.h"
#import "JBNavigationBarTitleView.h"
#import "JBBookmarkCatalogTableViewCell.h"
#import "JBBookmarkLoginController.h"
#import "JBBookmark.h"
#import "JBWebViewController.h"
/// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIBarButtonItem+Space.h"
#import "UIViewController+ModalAnimatedTransition.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "HatenaBookmarkSDK.h"
#import "IonIcons.h"
/// Pods-Extension
#import "SSGentleAlertView+Junkbox.h"


#pragma mark - JBBookmarkCatalogController
@implementation JBBookmarkCatalogController


#pragma mark - synthesize
@synthesize loginButtonView;
@synthesize searchButtonView;
@synthesize searchBar;
@synthesize loginModalViewController;
@synthesize bookmarkList;
@synthesize searchedBookmarkList;


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
    self.bookmarkList = nil;
    self.searchedBookmarkList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissLoginModalViewCntrollerWithNotification:)
                                                 name:kNotificationModalBookmarkLoginControllerWillDismiss
                                               object:nil];
    self.searchedBookmarkList = [NSMutableArray arrayWithArray:@[]];

    // Hatebu
    self.bookmarkList = [JBBookmarkList sharedInstance];
    [self.bookmarkList setDelegate:self];
    [self.bookmarkList loadFromLocal];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Bookmark", @"はてブ一覧")];
    self.navigationItem.titleView = titleView;
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:nil/*icon_log_in*/];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
                                      animated:NO];
        // 検索ボタン
    self.searchButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                    title:nil
                                                                     icon:icon_ios7_search_strong];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.searchButtonView]]
                                       animated:NO];
        // 検索バー
    CGRect searchBarRect = self.searchBar.frame;
    searchBarRect.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.searchBar.frame = searchBarRect;
    self.searchBar.placeholder = NSLocalizedString(@"Search", @"検索バーPlaceHolder");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.loginButtonView.alpha = ([HTBHatenaBookmarkManager sharedManager].authorized) ? 0.3f : 1.0f;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchedBookmarkList.count;
    }

    return self.bookmarkList.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBBookmark *bookmark = (tableView == self.searchDisplayController.searchResultsTableView) ?
        (JBBookmark *)self.searchedBookmarkList[indexPath.row] : (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
    return ([bookmark.summary isEqualToString:@""]) ?
        kJBBookmarkCatalogTableViewCellHeight - kJBBookmarkCatalogTableViewCellLabelHeight : kJBBookmarkCatalogTableViewCellHeight;
/*
    JBBookmark *bookmark = (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
    return [JBBookmarkCatalogTableViewCell cellHeightWithBookmarkComment:bookmark.summary];
*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBBookmarkCatalogTableViewCell class]);
    JBBookmarkCatalogTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];

        JBBookmark *bookmark = (tableView == self.searchDisplayController.searchResultsTableView) ?
            (JBBookmark *)self.searchedBookmarkList[indexPath.row] : (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
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

    JBBookmark *bookmark = (tableView == self.searchDisplayController.searchResultsTableView) ?
        (JBBookmark *)self.searchedBookmarkList[indexPath.row] : (JBBookmark *)[self.bookmarkList modelWithIndex:indexPath.row];
    if (bookmark) {
        // 遷移
        JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                        bundle:nil];
        [vc setInitialURL:[bookmark URL]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}


#pragma mark - UISearchDisplayDelegate
- (void)filterContentForSearchText:(NSString *)searchText
                             scope:(NSString *)scope
{
    [self.searchedBookmarkList removeAllObjects];

    NSArray *predicates = @[
        [NSPredicate predicateWithFormat:@"SELF.summary contains[c] %@", searchText],
        [NSPredicate predicateWithFormat:@"SELF.dcSubject contains[c] %@", searchText],
        [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText],
    ];
    NSArray *temporaryArray = [self.bookmarkList.list filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
    self.searchedBookmarkList = [NSMutableArray arrayWithArray:temporaryArray];
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
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
        if ([HTBHatenaBookmarkManager sharedManager].authorized) {
            [SSGentleAlertView showWithMessage:NSLocalizedString(@"Do you logout current account and login?", @"今ログインしているアカウントをログアウトしてからログインしますか？")
                                  buttonTitles:@[NSLocalizedString(@"No", @"いいえ"), NSLocalizedString(@"Yes", @"はい")]
                                      delegate:self];
        }
        else {
            [self prepareLogin];
        }
    }
    else if (barButtonView == self.searchButtonView) {
        [self.searchBar becomeFirstResponder];
    }
}


#pragma mark - JBBookmarkListDelegate
/**
 * Bookmark一覧取得成功
 * @param list 一覧
 */
- (void)bookmarkListDidFinishLoadWithList:(JBBookmarkList *)list
{
    //[self.pullToRefreshHeaderView finishRefreshing];
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
    //[self.pullToRefreshHeaderView finishRefreshing];
    [self.refreshControl endRefreshing];
    [[MTStatusBarOverlay sharedInstance] hide];
}


#pragma mark - SSGentleAlertViewDelegate
- (void)alertView:(SSGentleAlertView *)alertView
clickedButtonAtIndex:(NSInteger)index
{
    switch (index) {
        // No
        case 0:
            break;
        // Yes
        case 1:
            [self prepareLogin];
            break;
    }
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
- (void)scrollViewDidPulled
{
    // Statusbar
    [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Getting the bookmark list...", @"ブックマーク一覧取得")
                                            animated:YES];
    // Bookmark一覧インポート
    [self.bookmarkList loadFromWebAPI];
}


#pragma mark - private api
/**
 * はてなブックマークログインをする前の準備処理
 */
- (void)prepareLogin
{
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


@end
