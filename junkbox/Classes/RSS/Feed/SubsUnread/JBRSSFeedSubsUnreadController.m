#import "JBRSSFeedSubsUnreadController.h"
#import "JBRSSConstant.h"
#import "JBRSSFeedSubsUnreadTableViewCell.h"
#import "JBRSSFeedSubsUnread.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSLoginOperation.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "MTStatusBarOverlay.h"
/// UIKit-Extension
#import "UIStoryboard+UIKit.h"
#import "UINib+UIKit.h"


#pragma mark - JBRSSFeedSubsUnreadController
@implementation JBRSSFeedSubsUnreadController


#pragma mark - synthesize
@synthesize unreadList;


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
    self.unreadList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // 未読フィード一覧
    self.unreadList = [[JBRSSFeedSubsUnreadList alloc] initWithDelegate:self];

    // ログイン成功イベント
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidSuccess:)
                                                 name:kNotificationRSSLoginSuccess
                                               object:nil];

    // ログインボタン
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:kDefaultNavigationItemFrame];
    [loginButton setTitle:NSLocalizedString(@"Login", @"ログインボタンのタイトル")
                 forState:UIControlStateNormal];
    [loginButton addTarget:self
                    action:@selector(touchedUpInsideWithLoginButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:loginButton]]
                                      animated:NO];

    // 前回の起動で読み込み完了していたデータを読み込み
    [self.unreadList loadFeedFromLocal];
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
    return kLivedoorReaderMaxRate+1;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return kLivedoorReaderRateLabels[section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.unreadList feedCountWithRate:section];
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
        JBRSSFeedSubsUnread *unread = [self.unreadList unreadWithIndexPath:indexPath];
        cell.feedNameLabel.text = unread.title;
        cell.unreadCountLabel.text = [unread.unreadCount stringValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
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
    // ステータスバー
    [[MTStatusBarOverlay sharedInstance] hide];

    [self.tableView reloadData];
}

/**
 * 未読フィード一覧取得失敗
 * @param error error
 */
- (void)feedDidFailLoadWithError:(NSError *)error
{
    // エラー処理
    NSString *message = nil;
    switch (error.code) {
        case http::statusCode::UNAUTHORIZED: // 401
            // 再度ログイン後、未読フィード一覧ロード
            [self login];
            [self.unreadList loadFeedFromWebAPI];
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


#pragma mark - event listener
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button
{
    UINavigationController *vc = [UINavigationController new];
    [vc setViewControllers:@[[UIStoryboard UIKitFromName:kStoryboardRSSLogin]]];
    [self presentModalViewController:vc
                            animated:YES];
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
    [self.unreadList loadFeedFromWebAPI];
    dispatch_async(dispatch_get_main_queue(), ^ () {
        // ステータスバー
        [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Getting the unread feed list...", @"未読フィード一覧読み込み")
                                                animated:YES];
    });
}

/**
 * 認証切れの場合の再ログイン
 */
- (void)login
{
    JBRSSLoginOperation *operation = [[JBRSSLoginOperation alloc] initReauthenticationWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // ログインに失敗した場合、他のRSS関連の通信をすべて止める
        if (error) {
            [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
            // ステータスバー
            [[MTStatusBarOverlay sharedInstance] hide];
        }
    }];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}


@end
