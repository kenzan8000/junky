#import "JBSettingController.h"
#import "JBNavigationBarTitleView.h"
#import "JBSettingTableViewCell.h"
#import "JBSettingHeaderTableViewCell.h"
#import "JBSettingHintTableViewCell.h"
#import "JBSettingReviewTableViewCell.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBSettingController
@implementation JBSettingController


#pragma mark - synthesize
@synthesize cellList;
@synthesize cellTitleList;
@synthesize cellIconList;


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
    self.cellList = nil;
    self.cellTitleList = nil;
    self.cellIconList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    [self.refreshControl removeFromSuperview];

    [self initializeCellList];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Setting", @"設定タブ")];
    self.navigationItem.titleView = titleView;
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
    return self.cellList.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellList[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class classObject = self.cellList[indexPath.row];
    NSString *className = NSStringFromClass(classObject);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];

        JBSettingTableViewCell *c = (JBSettingTableViewCell *)cell;
        [c setTitleWithTitleString:self.cellTitleList[indexPath.row]];
        [c setIconWithImage:self.cellIconList[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}


#pragma mark - private api
/**
 * cell一覧に入るデータを設定
 */
- (void)initializeCellList
{
    self.cellList = [NSMutableArray arrayWithArray:@[
        [JBSettingHeaderTableViewCell class],
        [JBSettingHintTableViewCell class],
        [JBSettingHintTableViewCell class],
        [JBSettingHintTableViewCell class],
        [JBSettingHeaderTableViewCell class],
        [JBSettingReviewTableViewCell class],
        [JBSettingReviewTableViewCell class],
        [JBSettingReviewTableViewCell class],
        [JBSettingReviewTableViewCell class],
    ]];
    self.cellTitleList = [NSMutableArray arrayWithArray:@[
        NSLocalizedString(@"Hint", @"ヒント"),
        NSLocalizedString(@"Feed", @"フィード"),
        NSLocalizedString(@"Read Later", @"あとで読む"),
        NSLocalizedString(@"Bookmark", @"ブックマーク"),
        NSLocalizedString(@"Social", @"ソーシャル"),
        NSLocalizedString(@"Review", @"レビュー導線"),
        NSLocalizedString(@"Tweet", @"ツイートする"),
        NSLocalizedString(@"Publish", @"共有する"),
        NSLocalizedString(@"Pull Request", @"プルリクエストする"),
    ]];
    self.cellIconList = [NSMutableArray arrayWithArray:@[
        [IonIcons imageWithIcon:icon_help_circled size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_social_rss size:64 color:[UIColor colorWithHexadecimal:0xff9e42ff]],
        [IonIcons imageWithIcon:icon_pin size:64 color:[UIColor colorWithHexadecimal:0xff6c5cff]],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:64 color:[UIColor colorWithHexadecimal:0x54b8fbff]],
        [IonIcons imageWithIcon:icon_android_add_contact size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_social_apple size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
        [IonIcons imageWithIcon:icon_social_twitter size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
        [IonIcons imageWithIcon:icon_social_facebook size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
        [IonIcons imageWithIcon:icon_social_github size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
    ]];
}
@end
