#import "JBSettingController.h"
#import "JBHintViewController.h"
#import "JBNavigationBarTitleView.h"
#import "JBSettingTableViewCell.h"
#import "JBSettingHeaderTableViewCell.h"
#import "JBSettingHintTableViewCell.h"
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
@synthesize selectedIndexPath;


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
    self.selectedIndexPath = nil;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kStoryboardSeguePushHintController] == NO) {
        return;
    }

    // Hint
    JBHintViewController *vc = (JBHintViewController *)[segue destinationViewController];
    NSIndexPath *indexPath = self.selectedIndexPath;
    NSString *title = self.cellTitleList[indexPath.section][indexPath.row];
    NSArray *titles = @[@"Feed", @"Read Later", @"Bookmark",];
    for (NSString *t in titles) {
        if ([title isEqualToString:NSLocalizedString(t, @"ヒントの種類")]) {
            vc.hint = t;
            break;
        }
    }
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

        if ([cell isKindOfClass:[JBSettingSocialTableViewCell class]]) {
            [(JBSettingSocialTableViewCell *)cell setDelegate:self];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;

    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];

    NSString *title = self.cellTitleList[indexPath.section][indexPath.row];
    // ライセンス情報
    if ([title isEqualToString:NSLocalizedString(@"Licence", @"ライセンス情報")]) {
        [self performSegueWithIdentifier:kStoryboardSeguePushLicenceController
                                  sender:self];
    }
    // ヒント
    else if ([title isEqualToString:NSLocalizedString(@"Feed", @"フィード")] ||
        [title isEqualToString:NSLocalizedString(@"Read Later", @"あとで読む")] ||
        [title isEqualToString:NSLocalizedString(@"Bookmark", @"ブックマーク")]) {
        [self performSegueWithIdentifier:kStoryboardSeguePushHintController
                                  sender:self];
    }
}


#pragma mark - JBSettingSocialTableViewCellDelegate
/**
 * presentViewControllerするためのDelegate
 * @param vc presentするvc
 * @param cell JBSettingSocialTableViewCell
 */
- (void)presentViewController:(UIViewController *)vc
                         cell:(JBSettingSocialTableViewCell *)cell
{
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}


#pragma mark - private api
/**
 * cell一覧に入るデータを設定
 */
- (void)initializeCellList
{
    self.sectionTitleList = @[
//        NSLocalizedString(@"RSS Reader", @"RSSリーダー"),
//        NSLocalizedString(@"Social Bookmark", @"ソーシャルブックマーク"),
        NSLocalizedString(@"Hint", @"ヒント"),
        NSLocalizedString(@"Social", @"ソーシャル"),
        NSLocalizedString(@"Licence", @"ライセンス情報"),
    ];
    self.sectionIconList = @[
//        [IonIcons imageWithIcon:icon_social_rss size:64 color:[UIColor darkGrayColor]],
//        [IonIcons imageWithIcon:icon_ios7_bookmarks size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_help_circled size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_android_friends size:64 color:[UIColor darkGrayColor]],
        [IonIcons imageWithIcon:icon_ios7_copy size:64 color:[UIColor darkGrayColor]],
    ];

    self.cellClassList = @[
//        @[
//        ],
//        @[
//        ],
        @[
            [JBSettingHintTableViewCell class],
            [JBSettingHintTableViewCell class],
            [JBSettingHintTableViewCell class],
        ],
        @[
            [JBSettingSocialTableViewCell class],
            [JBSettingSocialTableViewCell class],
            [JBSettingSocialTableViewCell class],
//            [JBSettingSocialTableViewCell class],
        ],
        @[
            [JBSettingLicenceTableViewCell class],
        ],
    ];
    self.cellTitleList = @[
//        @[
//        ],
//        @[
//        ],
        @[
            NSLocalizedString(@"Feed", @"フィード"),
            NSLocalizedString(@"Read Later", @"あとで読む"),
            NSLocalizedString(@"Bookmark", @"ブックマーク"),
        ],
        @[
            NSLocalizedString(@"Review", @"レビュー導線"),
            NSLocalizedString(@"Tweet", @"ツイートする"),
            NSLocalizedString(@"Publish", @"共有する"),
//            NSLocalizedString(@"Pull Request", @"プルリクエストする"),
        ],
        @[
            NSLocalizedString(@"Licence", @"ライセンス情報"),
        ],
    ];
    self.cellIconList = @[
//        @[
//        ],
//        @[
//        ],
        @[
            [IonIcons imageWithIcon:icon_social_rss size:64 color:[UIColor colorWithHexadecimal:0x888888ff]],
            [IonIcons imageWithIcon:icon_pin size:64 color:[UIColor colorWithHexadecimal:0x888888ff]],
            [IonIcons imageWithIcon:icon_ios7_bookmarks size:64 color:[UIColor colorWithHexadecimal:0x888888ff]],
        ],
        @[
            [IonIcons imageWithIcon:icon_compose size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],//icon_social_apple
            [IonIcons imageWithIcon:icon_social_twitter size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_social_facebook size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
//            [IonIcons imageWithIcon:icon_social_github size:32 color:[UIColor colorWithHexadecimal:0xffffffff]],
        ],
        @[
            [IonIcons imageWithIcon:icon_ios7_copy size:64 color:[UIColor colorWithHexadecimal:0x888888ff]],
        ],
    ];
}


@end
