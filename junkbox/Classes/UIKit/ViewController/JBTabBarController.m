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
    UIColor *selectedColor = [UIColor colorWithHexadecimal:0xaaaaaaff];
    UIColor *color = [UIColor colorWithHexadecimal:0x0080ffff];
    // 選択
    NSArray *selectedImages = @[
        [IonIcons imageWithIcon:icon_social_rss size:30 color:selectedColor],
        [IonIcons imageWithIcon:icon_pin size:30 color:selectedColor],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:30 color:selectedColor],
        [IonIcons imageWithIcon:icon_gear_b size:30 color:selectedColor],
    ];
    // 未選択
    NSArray *images = @[
        [IonIcons imageWithIcon:icon_social_rss size:30 color:color],
        [IonIcons imageWithIcon:icon_pin size:30 color:color],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:30 color:color],
        [IonIcons imageWithIcon:icon_gear_b size:30 color:color],
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
        [item setFinishedSelectedImage:images[i]
           withFinishedUnselectedImage:selectedImages[i]];
        [item setTitle:titles[i]];
    }
    // テキスト色
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:selectedColor}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:color}
                                             forState:UIControlStateSelected];
}


@end
