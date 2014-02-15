#import "TableViewController.h"
// UIKit-Extension
#import "UINib+UIKit.h"


#pragma mark - TableViewController
@implementation TableViewController


#pragma mark - synthesize
@synthesize tableView;
@synthesize refreshControl;
//@synthesize pullToRefreshHeaderView;


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
    [self.refreshControl removeFromSuperview];
    self.refreshControl = nil;
//    self.pullToRefreshHeaderView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // Pull to Refresh
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(scrollViewDidPulled)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
/*
    self.tableView.delegate = self;

    // Pull to Refresh
    self.pullToRefreshHeaderView = [UINib UIKitFromClassName:NSStringFromClass([JBPullToRefreshHeaderView class])];
    [self.pullToRefreshHeaderView setDelegate:self];
    [self.pullToRefreshHeaderView setScrollView:self.tableView];
*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.pullToRefreshHeaderView finishRefreshingWithAnimated:NO];
    [self.refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.pullToRefreshHeaderView finishRefreshingWithAnimated:NO];
    [self.refreshControl endRefreshing];
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

/*
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullToRefreshHeaderView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [self.pullToRefreshHeaderView scrollViewDidEndDragging:scrollView
                                            willDecelerate:decelerate];
}

#pragma mark - JBPullToRefreshHeaderViewDelegate
- (void)scrollViewDidPulled
{
}
*/

#pragma mark - event listener
- (void)scrollViewDidPulled
{
}


@end
