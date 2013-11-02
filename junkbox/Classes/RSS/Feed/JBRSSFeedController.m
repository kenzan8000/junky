#import "JBRSSFeedController.h"
/// Connection
#import "StatusCode.h"
#import "ISHTTPOperation.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"
/// UIKit-Extension
#import "UIStoryboard+UIKit.h"


#pragma mark - JBRSSFeedController
@implementation JBRSSFeedController


#pragma mark - synthesize
@synthesize loginButton;


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
    self.loginButton = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ログインボタン
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setFrame:kDefaultNavigationItemFrame];
    [self.loginButton setTitle:NSLocalizedString(@"Login", @"ログインボタンのタイトル")
                      forState:UIControlStateNormal];
    [self.loginButton addTarget:self
                         action:@selector(touchedUpInsideWithLoginButton:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.loginButton]]
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
    [self presentViewController:[UIStoryboard UIKitFromName:kStoryboardRSSLogin]
                       animated:YES
                     completion:^ () {}];
}


#pragma mark - api
- (void)loadFeed
{
    // 未読フィード一覧
    NSMutableURLRequest *request = [NSMutableURLRequest JBRSSSubsUnreadRequest];
    [ISHTTPOperation sendRequest:request
                         handler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        JBLog(@"%@", [object JSON]);
    }];
}


@end
