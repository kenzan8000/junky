#import "JBRSSPinController.h"
#import "JBRSSPinTableViewCell.h"
#import "JBRSSPinList.h"
#import "JBRSSPin.h"
#import "JBWebViewController.h"
#import "JBNavigationBarTitleView.h"
// NSFoundation-Extension
#import "NSData+JSON.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIStoryboard+UIKit.h"
#import "UIViewController+ModalAnimatedTransition.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBRSSPinController
@implementation JBRSSPinController


#pragma mark - synthesize
@synthesize pinList;


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

    self.pinList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    self.pinList = [JBRSSPinList sharedInstance];
    [self.pinList setDelegate:self];

    // ログイン成功イベント
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidSuccess:)
                                                 name:kNotificationRSSLoginSuccess
                                               object:nil];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Read Later", @"あとで読む")];
    self.navigationItem.titleView = titleView;
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:nil/*icon_log_in*/];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
                                      animated:NO];
        //
    JBBarButtonView *emptyButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                               title:nil
                                                                                icon:icon_ios7_search_strong];
    [emptyButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:emptyButtonView]]
                                       animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return [self.pinList count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kJBRSSPinTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBRSSPinTableViewCell class]);
    JBRSSPinTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];
        {// テキスト
        JBRSSPin *pin = [self.pinList pinWithIndex:indexPath.row];
        [cell setTitleName:pin.title];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell選択
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    // 既読化
    JBRSSPin *pin = [self.pinList pinWithIndex:indexPath.row];
    if (pin) {
        [self.pinList removePinWithLink:pin.link];
    }
}


#pragma mark - JBRSSPinListDelegate
/**
 * あとで読む(Livedoor Reader PIN)一覧取得成功
 * @param list 一覧
 */
- (void)pinDidFinishLoadWithList:(JBRSSPinList *)list
{
    //[self.pullToRefreshHeaderView finishRefreshing];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

/**
 * あとで読む(Livedoor Reader PIN)一覧取得失敗
 * @param error error
 */
- (void)pinDidFailLoadWithError:(NSError *)error
{
    //[self.pullToRefreshHeaderView finishRefreshing];
    [self.refreshControl endRefreshing];
}

/**
 * あとで読む(Livedoor Reader PIN)を削除した
 * @param list 一覧
 * @param link 削除したリンク
 * @param index 削除した行
 */
- (void)pinDidDeleteWithList:(JBRSSPinList *)list
                        link:(NSString *)link
                       index:(NSInteger)index
{
    if (index < 0) { return; }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];

    // 遷移
    JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                    bundle:nil];
    [vc setInitialURL:[NSURL URLWithString:link]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc
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
    [self.pinList loadAllPinFromWebAPI];
}


#pragma mark - notification
/**
 * ログイン成功
 * @param notification notification
 **/
- (void)loginDidSuccess:(NSNotification *)notification
{
    [self.pinList loadAllPinFromWebAPI];
}


@end
