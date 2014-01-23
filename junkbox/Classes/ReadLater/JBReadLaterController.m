#import "JBReadLaterController.h"
#import "JBReadLaterTableViewCell.h"
#import "JBRSSPinList.h"
#import "JBRSSPin.h"
#import "JBWebViewController.h"
// NSFoundation-Extension
#import "NSData+JSON.h"
/// UIKit-Extension
#import "UINib+UIKit.h"


#pragma mark - JBReadLaterController
@implementation JBReadLaterController


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
    return [self.pinList count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kJBReadLaterTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBReadLaterTableViewCell class]);
    JBReadLaterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
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

        // 遷移
        JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                        bundle:nil];
        [vc setInitialURL:[NSURL URLWithString:pin.link]];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}


#pragma mark - JBRSSPinListDelegate
/**
 * あとで読む(Livedoor Reader PIN)一覧取得成功
 * @param list 一覧
 */
- (void)pinDidFinishLoadWithList:(JBRSSPinList *)list
{
}

/**
 * あとで読む(Livedoor Reader PIN)一覧取得失敗
 * @param error error
 */
- (void)pinDidFailLoadWithError:(NSError *)error
{
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
