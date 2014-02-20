#import "JBSettingController.h"
#import "JBNavigationBarTitleView.h"
#import "JBSettingTableViewCell.h"
#import "JBSettingHeaderTableViewCell.h"
#import "JBSettingHintTableViewCell.h"
#import "JBSettingSocialTableViewCell.h"
#import "JBSettingLicenceTableViewCell.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBSettingController
@implementation JBSettingController


#pragma mark - synthesize
@synthesize cellClassList;
@synthesize cellTitleList;
@synthesize cellIconList;
@synthesize sectionTitleList;
@synthesize sectionIconList;

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
    self.cellClassList = nil;
    self.cellTitleList = nil;
    self.cellIconList = nil;
    self.sectionTitleList = nil;
    self.sectionIconList = nil;
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
    return self.cellClassList.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)(self.cellClassList[section]) count];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    NSString *className = NSStringFromClass([JBSettingHeaderTableViewCell class]);
    JBSettingHeaderTableViewCell *cell = (JBSettingHeaderTableViewCell *)[UINib UIKitFromClassName:className];
    [cell setTitleWithTitleString:self.sectionTitleList[section]];
    [cell setIconWithImage:self.sectionIconList[section]];
    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    UIView *headerView = [UIView new];
    [headerView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:cell];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *classes = (NSArray *)(self.cellClassList[indexPath.section]);
    return [classes[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class classObject = (NSArray *)(self.cellClassList)[indexPath.section][indexPath.row];
    NSString *className = NSStringFromClass(classObject);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];

        JBSettingTableViewCell *c = (JBSettingTableViewCell *)cell;
        [c setTitleWithTitleString:self.cellTitleList[indexPath.section][indexPath.row]];
        [c setIconWithImage:self.cellIconList[indexPath.section][indexPath.row]];
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
    self.sectionTitleList = @[
        NSLocalizedString(@"Hint", @"ヒント"),
        NSLocalizedString(@"RSS Reader", @"RSSリーダー"),
        NSLocalizedString(@"Social Bookmark", @"ソーシャルブックマーク"),
        NSLocalizedString(@"Social", @"ソーシャル"),
        NSLocalizedString(@"Licence", @"ライセンス情報"),
    ];
    self.sectionIconList = @[
        [IonIcons imageWithIcon:icon_help_circled size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_social_rss size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_android_friends size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_ios7_copy size:64 color:[UIColor darkGrayColor]],
    ];

    self.cellClassList = @[
        @[
            [JBSettingHintTableViewCell class],
            [JBSettingHintTableViewCell class],
            [JBSettingHintTableViewCell class],
        ],
        @[
        ],
        @[
        ],
        @[
            [JBSettingSocialTableViewCell class],
            [JBSettingSocialTableViewCell class],
            [JBSettingSocialTableViewCell class],
            [JBSettingSocialTableViewCell class],
        ],
        @[
            [JBSettingLicenceTableViewCell class],
        ],
    ];
    self.cellTitleList = @[
        @[
            NSLocalizedString(@"Feed", @"フィード"),
            NSLocalizedString(@"Read Later", @"あとで読む"),
            NSLocalizedString(@"Bookmark", @"ブックマーク"),
        ],
        @[
        ],
        @[
        ],
        @[
            NSLocalizedString(@"Review", @"レビュー導線"),
            NSLocalizedString(@"Tweet", @"ツイートする"),
            NSLocalizedString(@"Publish", @"共有する"),
            NSLocalizedString(@"Pull Request", @"プルリクエストする"),
        ],
        @[
            NSLocalizedString(@"Licence", @"ライセンス情報"),
        ],
    ];
    self.cellIconList = @[
        @[
            [IonIcons imageWithIcon:icon_social_rss size:64 color:[UIColor colorWithHexadecimal:0xff9e42ff]],
            [IonIcons imageWithIcon:icon_pin size:64 color:[UIColor colorWithHexadecimal:0xff6c5cff]],
            [IonIcons imageWithIcon:icon_ios7_bookmarks size:64 color:[UIColor colorWithHexadecimal:0x54b8fbff]],
        ],
        @[
        ],
        @[
        ],
        @[
            [IonIcons imageWithIcon:icon_social_apple size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_social_twitter size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_social_facebook size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_social_github size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
        ],
        @[
            [IonIcons imageWithIcon:icon_ios7_copy size:64 color:[UIColor colorWithHexadecimal:0x2ecc71ff]],
        ],
    ];
}
@end
