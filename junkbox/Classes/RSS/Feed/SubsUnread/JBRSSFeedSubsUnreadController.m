#import "JBRSSFeedSubsUnreadController.h"
#import "JBRSSFeedUnreadController.h"
#import "JBRSSConstant.h"
#import "JBRSSFeedSubsUnreadTableViewCell.h"
#import "JBRSSFeedSubsUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedUnreadLists.h"
#import "JBNavigationBarTitleView.h"
#import "JBOutlineLabel.h"
#import "UIViewController+ModalAnimatedTransition.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "IonIcons.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"
#import "UIStoryboard+UIKit.h"
#import "UINib+UIKit.h"


#pragma mark - JBRSSFeedSubsUnreadController
@implementation JBRSSFeedSubsUnreadController


#pragma mark - synthesize
@synthesize subsUnreadList;
@synthesize unreadLists;
@synthesize indexOfselectCell;
@synthesize loginButtonView;


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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.unreadLists = nil;
    self.subsUnreadList = nil;
    self.loginButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // 未読フィード一覧
    self.subsUnreadList = [[JBRSSFeedSubsUnreadList alloc] initWithDelegate:self];

    // ログイン成功イベント
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidSuccess:)
                                                 name:kNotificationRSSLoginSuccess
                                               object:nil];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Feed", @"フィードタブ")];
    self.navigationItem.titleView = titleView;
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:nil/*icon_log_in*/];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
                                      animated:NO];
        //
    JBBarButtonView *menuButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                              title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                               icon:icon_navicon_round];
    [menuButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:menuButtonView]]
                                       animated:NO];

    // 前回の起動で読み込み完了していたデータを読み込み
    [self.subsUnreadList loadFeedFromLocal];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kStoryboardSeguePushRSSFeedUnreadController]) {
        JBRSSFeedUnreadController *vc = (JBRSSFeedUnreadController *)[segue destinationViewController];
        JBRSSFeedUnreadList *unread = [self.unreadLists listWithIndex:self.indexOfselectCell];
        [vc setUnreadList:unread];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kLivedoorReaderMaxRate+1;
}
/*
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return kLivedoorReaderRateLabels[section];
}
*/
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.subsUnreadList feedCountWithRate:section];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    JBOutlineLabel *label = [JBOutlineLabel new];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    [label setTextColor:[UIColor colorWithHexadecimal:0xf1c40fff]];
    [label setText:kLivedoorReaderRateLabels[section]];
    [label setOutlineColor:[UIColor colorWithHexadecimal:0x7f8c8dff]];
    [label setOutlineWidth:0.7f];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFrame:CGRectMake(16, 0, self.view.frame.size.width-16*2, 20)];
    UIView *headerView = [UIView new];
    [headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithHexadecimal:0xecf0f1ff]];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kJBRSSFeedSubsUnreadTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBRSSFeedSubsUnreadTableViewCell class]);
    JBRSSFeedSubsUnreadTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];
        {// テキスト
        JBRSSFeedSubsUnread *unread = [self.subsUnreadList unreadWithIndexPath:indexPath];
        [cell setFeedName:unread.title];
        [cell setUnreadCount:unread.unreadCount];
        }
        {// デザイン
        JBRSSFeedUnreadList *unread = [self.unreadLists listWithIndex:[self.subsUnreadList indexWithIndexPath:indexPath]];
        [cell designWithIsFinishedLoading:[unread isFinishedLoading]
                                 isUnread:[unread isUnread]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell選択
    self.indexOfselectCell = [self.subsUnreadList indexWithIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    // 既読化
    JBRSSFeedSubsUnreadTableViewCell *cell = (JBRSSFeedSubsUnreadTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    JBRSSFeedUnreadList *unread = [self.unreadLists listWithIndex:[self.subsUnreadList indexWithIndexPath:indexPath]];
    if ([unread isFinishedLoading]) {
        [unread setIsUnread:NO];
        [cell designWithIsFinishedLoading:[unread isFinishedLoading]
                                 isUnread:[unread isUnread]];
    }
    // 遷移
    [self performSegueWithIdentifier:kStoryboardSeguePushRSSFeedUnreadController
                              sender:self];
}


#pragma mark - JBRSSFeedSubsUnreadListDelegate
/**
 * 未読フィード一覧取得成功
 * @param list 一覧
 */
- (void)feedDidFinishLoadWithList:(JBRSSFeedSubsUnreadList *)list
{
    //[self.pullToRefreshHeaderView finishRefreshing];
    [self.refreshControl endRefreshing];

    // ステータスバー
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^ () {
        [[MTStatusBarOverlay sharedInstance] hide];
    });
    [self.tableView reloadData];

    // 詳細フィード一覧
    self.unreadLists = [[JBRSSFeedUnreadLists alloc] initWithSubsUnreadList:list
                                                              listsDelegate:self];
    for (NSInteger i = 0; i < [self.unreadLists count]; i++) {
        [self.unreadLists loadWithIndex:i];
    }
}

/**
 * 未読フィード一覧取得失敗
 * @param error error
 */
- (void)feedDidFailLoadWithError:(NSError *)error
{
    //[self.pullToRefreshHeaderView finishRefreshing];
    [self.refreshControl endRefreshing];

    // エラー処理
    NSString *message = nil;
    switch (error.code) {
        case http::statusCode::UNAUTHORIZED: // 401
            // 再認証
            break;
        case http::NOT_REACHABLE:
            message = NSLocalizedString(@"Cannot access the Network.", @"通信できない");
            break;
        case http::TIMEOUT:
            message = NSLocalizedString(@"Cannot access the Network.", @"タイムアウト");
            break;
        default:
            // 4xx
            if (error.code < http::statusCode::SERVER_ERROR) {
                message = NSLocalizedString(@"Cannot access the Network.", @"4xx");
            }
            // 5xx
            else {
                message = NSLocalizedString(@"Failure occurred in the system. Place the time and try again.", @"5xx");
            }
            break;
    }
    if (message && error.code != http::statusCode::UNAUTHORIZED) {
        // ステータスバー
        [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:message
                                                              duration:2.5f
                                                              animated:YES];
    }
}


#pragma mark - JBRSSFeedUnreadListsDelegate
- (void)unreadListsDidFinishLoadWithList:(JBRSSFeedUnreadList *)list
{
    NSInteger index = [self.unreadLists indexWithList:list];
    if (index < 0) { return; }

    // 表示を更新
    NSIndexPath *indexPath = [self.subsUnreadList indexPathWithIndex:index];
    if ([[self.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)unreadListsDidFailLoadWithError:(NSError *)error
                                   list:(JBRSSFeedUnreadList *)list
{
    // エラー処理
    switch (error.code) {
        case http::statusCode::UNAUTHORIZED: // 401
            // 再度ログイン後、フィードのリストをロード
            break;
        default:
            break;
    }
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
        UINavigationController *vc = [UINavigationController new];
        [vc setViewControllers:@[[UIStoryboard UIKitFromName:kStoryboardRSSLogin]]];
        [self presentViewController:vc
                         JBAnimated:YES
                         completion:^ () {}];
    }
}


#pragma mark - event listener
- (void)scrollViewDidPulled
{
    [self loadFeedFromWebAPI];
}


#pragma mark - notification
/**
 * ログイン成功
 * @param notification notification
 **/
- (void)loginDidSuccess:(NSNotification *)notification
{
    [self performSelector:@selector(loadFeedFromWebAPI)
               withObject:nil
               afterDelay:1.0f];
}


#pragma mark - private api
/**
 * 未読フィード読み込み
 */
- (void)loadFeedFromWebAPI
{
    // 詳細の読み込み停止
    [self.unreadLists stopAllLoading];
    // 一覧の読み込み開始
    [self.subsUnreadList loadFeedFromWebAPI];
    dispatch_async(dispatch_get_main_queue(), ^ () {
        // ステータスバー
        [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Getting the unread feed list...", @"未読フィード一覧読み込み")
                                                animated:YES];
    });
}


@end
