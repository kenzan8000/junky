#import "JBBookmarkCatalogController.h"
/// UIKit-Extension
#import "UINib+UIKit.h"


#pragma mark - JBBookmarkCatalogController
@implementation JBBookmarkCatalogController


#pragma mark - synthesize


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
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ログインボタン
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:kDefaultNavigationItemFrame];
    [loginButton setTitle:NSLocalizedString(@"Login", @"ログインボタンのタイトル")
                 forState:UIControlStateNormal];
    [loginButton addTarget:self
                    action:@selector(touchedUpInsideWithLoginButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:loginButton]]
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


#pragma mark - event listener
- (IBAction)touchedUpInsideWithLoginButton:(UIButton *)button
{
}


@end