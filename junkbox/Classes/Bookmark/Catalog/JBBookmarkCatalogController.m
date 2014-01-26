#import "JBBookmarkCatalogController.h"
/// UIKit-Extension
#import "UINib+UIKit.h"
/// Pods
#import "HatenaBookmarkSDK.h"
#import "IonIcons.h"


#pragma mark - JBBookmarkCatalogController
@implementation JBBookmarkCatalogController


#pragma mark - synthesize
@synthesize loginButtonView;


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
    self.loginButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ナビゲーションバー
        // ログインボタン
    self.loginButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                   title:NSLocalizedString(@"Login", @"ログインボタン")
                                                                    icon:icon_log_in];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButtonView]]
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


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    // ログイン
    if (barButtonView == self.loginButtonView) {
    }
}


#pragma mark - notification
-(void)showOAuthLoginView:(NSNotification *)notification
{
}


#pragma mark - event listener


@end
