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
    UIColor *selectedColor = [UIColor colorWithHexadecimal:0xffaf00ff];
    // 選択
    NSArray *selectedImages = @[
        [IonIcons imageWithIcon:icon_social_rss size:36 color:selectedColor],
        [IonIcons imageWithIcon:icon_pin size:36 color:selectedColor],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:36 color:selectedColor],
        [IonIcons imageWithIcon:icon_gear_b size:36 color:selectedColor],

    ];
    // 未選択
    NSArray *images = @[
        [IonIcons imageWithIcon:icon_social_rss size:36 color:unselectedColor],
        [IonIcons imageWithIcon:icon_pin size:36 color:unselectedColor],
        [IonIcons imageWithIcon:icon_ios7_bookmarks size:36 color:unselectedColor],
        [IonIcons imageWithIcon:icon_gear_b size:36 color:unselectedColor],
    ];
    for (NSInteger i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setSelectedImage:selectedImages[i]];
        [item setImage:images[i]];
        [item setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    }
    // 背景色
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexadecimal:0xecf0f1ff]];
}


@end
