#import "JBTabBarController.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBTabBarController
@implementation JBTabBarController


#pragma mark - synthesize


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    [self designTabBar];
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


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar
 didSelectItem:(UITabBarItem *)item
{
}


#pragma mark - private api
/**
 * タブバーのデザイン
 */
- (void)designTabBar
{
    UIColor *unselectedColor = [UIColor colorWithHexadecimal:0xaaaaaaff];
    // 選択
    NSArray *selectedImages = @[
        [IonIcons imageWithIcon:icon_social_rss size:30 color:[UIColor colorWithHexadecimal:0xff9e42ff]],
        [IonIcons imageWithIcon:icon_pin size:30 color:[UIColor colorWithHexadecimal:0xff6c5cff]],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:30 color:[UIColor colorWithHexadecimal:0x54b8fbff]],
        [IonIcons imageWithIcon:icon_gear_b size:30 color:[UIColor colorWithHexadecimal:0x5f6c6dff]],
    ];
    // 未選択
    NSArray *images = @[
        [IonIcons imageWithIcon:icon_social_rss size:30 color:unselectedColor],
        [IonIcons imageWithIcon:icon_pin size:30 color:unselectedColor],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:30 color:unselectedColor],
        [IonIcons imageWithIcon:icon_gear_b size:30 color:unselectedColor],
    ];
    // ラベル
    NSArray *titles = @[
        NSLocalizedString(@"Feed", nil),
        NSLocalizedString(@"Read Later", nil),
        NSLocalizedString(@"Bookmark", nil),
        NSLocalizedString(@"Setting", nil),
    ];
    for (NSInteger i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setSelectedImage:selectedImages[i]];
        [item setImage:images[i]];
        [item setTitle:titles[i]];
    }
    // テキスト色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectedColor}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexadecimal:0x2c3e50ff]}
                                             forState:UIControlStateSelected];

    // 背景色
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexadecimal:0xecf0f1ff]];
}

/**
 * タブタイトルの選択時の色
 */
- (void)designTabBarWithIndex:(NSInteger)index
{
}


@end
