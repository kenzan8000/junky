//#import "JBPullToRefreshHeaderView.h"


#pragma mark - TableViewController
/// TableViewController
@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}
/*
@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, JBPullToRefreshHeaderViewDelegate> {
}
*/


#pragma mark - property
/// tableview
@property (nonatomic, weak) IBOutlet UITableView *tableView;
/// Pull to Refresh
@property (nonatomic, strong) UIRefreshControl *refreshControl;
/*
/// pull to refresh
@property (nonatomic, strong) JBPullToRefreshHeaderView *pullToRefreshHeaderView;
*/


@end
