#import "JBReadLaterController.h"
/// UIKit-Extension
#import "UINib+UIKit.h"


#pragma mark - JBReadLaterController
@implementation JBReadLaterController


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
//    [self setViewControllers:@[[UIStoryboard UIKitFromName:kStoryboardReadLater]]];
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


@end
