#import <QuartzCore/QuartzCore.h>
#import "JBRSSDiscover.h"
#import "JBRSSDiscoverPopupViewController.h"
#import "JBRSSDiscoverTableViewCell.h"
// UIKit-Extension
#import "UINib+UIKit.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBRSSDiscoverPopupViewController
@implementation JBRSSDiscoverPopupViewController


#pragma mark - synthesize
@synthesize contentView;
@synthesize titleLabel;
@synthesize closeButton;
@synthesize tableView;
@synthesize feedList;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.feedList = [NSMutableArray arrayWithArray:@[]];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.feedList = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = true;

    self.contentView.layer.shadowOpacity = 0.7f;
    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];

    [self.titleLabel setText:NSLocalizedString(@"Please select a feed to be registered", @"登録するフィードを選択してください")];
    [self.closeButton setImage:[IonIcons imageWithIcon:icon_close_round
                                                  size:22
                                                 color:[UIColor whiteColor]]
                      forState:UIControlStateNormal];
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
    return [self.feedList count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JBRSSDiscoverTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([JBRSSDiscoverTableViewCell class]);
    JBRSSDiscoverTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [UINib UIKitFromClassName:className];

        JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:indexPath.row];
        if (discover) {
            [cell setDiscover:discover];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    [self dismissPopup];
}


#pragma mark - api
- (void)setJSON:(NSArray *)JSON
{
    NSMutableArray *list = [JBRSSDiscover JBRSSDiscoverListWithJSON:JSON];
    if (list) { self.feedList = list; }
}


#pragma mark - private api
- (void)touchesBegan:(NSSet*)touches
           withEvent:(UIEvent*)event
{
    CGPoint touchPos = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.contentView.frame, touchPos) == NO) {
        [self dismissPopup];
    }
}


@end