#import "JBHTBBookmarkViewController.h"
#import "JBNavigationBarTitleView.h"
// UIKit-Extension
#import "UIBarButtonItem+Space.h"
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBHTBBookmarkViewController
@implementation JBHTBBookmarkViewController


#pragma mark - synthesize
@synthesize closeButton;


#pragma mark - initializer


#pragma mark - release
- (void)dealloc
{
    self.closeButton = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // NavigationBar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexadecimal:0x4682b4ff];
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Hatena Bookmark", @"はてブ")];
    self.navigationItem.titleView = titleView;
        // 閉じるボタン
    self.closeButton = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                               title:nil
                                                                icon:icon_android_close];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.closeButton]]
                                      animated:NO];
        //
    JBBarButtonView *emptyButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                               title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                                icon:icon_navicon];
    [emptyButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:emptyButtonView]]
                                       animated:NO];
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


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    if (barButtonView == self.closeButton) {
        // dismiss
        [self dismissViewControllerAnimated:YES
                                 completion:^ () { }];
    }
}


@end
