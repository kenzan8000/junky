#import "JBRSSFeedSubsUnreadController.h"
#import "JBRSSFeedSubsUnreadOperation.h"
/// Connection
#import "StatusCode.h"
/// Pods
#import "MTStatusBarOverlay.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"
/// UIKit-Extension
#import "UIStoryboard+UIKit.h"
/// Pods-Extension
#import "SSGentleAlertView+Junkbox.h"
#import "JBRSSLoginOperation.h"
#import "JBRSSOperationQueue.h"


#pragma mark - JBRSSFeedSubsUnreadController
@implementation JBRSSFeedSubsUnreadController


#pragma mark - synthesize


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
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

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
    [self performSelector:@selector(loadFeed)
               withObject:nil
               afterDelay:1.5f];
}


#pragma mark - api
- (void)loadFeed
{
    // 未読フィード一覧
    JBRSSFeedSubsUnreadOperation *operation = [[JBRSSFeedSubsUnreadOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            JBLog(@"%@", [object JSON]);
            return;
        }

        // エラー処理
        NSString *alertViewMessage = nil;
        switch (error.code) {
            case http::statusCode::UNAUTHORIZED:
                // 再度ログイン後、未読フィード一覧ロード
                [self login];
                [self loadFeed];
                break;
            case http::NOT_REACHABLE:
                alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"通信できない");
                break;
            case http::TIMEOUT:
                alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"タイムアウト");
                break;
            default:
                // 4xx
                if (error.code < http::statusCode::SERVER_ERROR) {
                    alertViewMessage = NSLocalizedString(@"Cannot access the Network.", @"4xx");
                }
                // 5xx
                else {
                    alertViewMessage = NSLocalizedString(@"Failure occurred in the system. Place the time and try again.", @"5xx");
                }
                break;
        }
        if (alertViewMessage) {
            dispatch_async(dispatch_get_main_queue(), ^ () {
                // アラート
                [SSGentleAlertView showWithMessage:alertViewMessage
                                      buttonTitles:@[NSLocalizedString(@"Confirm", @"確認")]
                                          delegate:nil];
            });
        }
    }];

    [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Getting the unread feed list...", @"未読フィード一覧読み込み")
                                            animated:YES];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}


#pragma mark - private api
/**
 * 認証切れの場合の再ログイン
 */
- (void)login
{
/*
    JBRSSLoginOperation *operation = [[JBRSSLoginOperation alloc] initWithUsername:
                                                                          password:
                                                                           handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // ログインに失敗した場合、他のRSS関連の通信をすべて止める
        if (error) {
            [[JBRSSOperationQueue defaultQueue] cancelAllOperations];
        }
    }];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
*/
}


@end
