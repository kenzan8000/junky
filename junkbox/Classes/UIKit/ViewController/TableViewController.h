#pragma mark - TableViewController
/// TableViewController
@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}


#pragma mark - property
/// tableview
@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end
