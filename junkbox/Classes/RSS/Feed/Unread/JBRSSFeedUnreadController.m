#import "JBRSSFeedUnreadController.h"
//#import "JBRSSConstant.h"
//#import "JBRSSFeedUnreadTableViewCell.h"
//#import "JBRSSFeedUnread.h"
//#import "JBRSSOperationQueue.h"
//#import "JBRSSLoginOperation.h"
/// Connection
//#import "StatusCode.h"
/// Pods
//#import "MTStatusBarOverlay.h"
/// UIKit-Extension
//#import "UIStoryboard+UIKit.h"
#import "UINib+UIKit.h"


#pragma mark - JBRSSFeedUnreadController
@implementation JBRSSFeedUnreadController


#pragma mark - synthesize
//@synthesize unreadList;


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
//    self.unreadList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
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

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;//kJBRSSFeedUnreadTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *className = NSStringFromClass([JBRSSFeedUnreadTableViewCell class]);
    //JBRSSFeedUnreadTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    NSString *className = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        //cell = [UINib UIKitFromClassName:className];
        cell = [UITableViewCell new];
    }
    return cell;
}


#pragma mark - private api


@end
