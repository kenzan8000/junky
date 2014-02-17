#import <QuartzCore/QuartzCore.h>
#import "JBRSSDiscover.h"
#import "JBRSSDiscoverPopupViewController.h"
// Pods-Extension
#import "JBQBFlatButton.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"


#pragma mark - JBRSSDiscoverPopupViewController
@implementation JBRSSDiscoverPopupViewController


#pragma mark - synthesize
@synthesize contentView;
@synthesize titleLabel;
@synthesize tableView;
@synthesize decideButton;
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

    [self.decideButton setFaceColor:[UIColor colorWithHexadecimal:0xff7058ff] forState:UIControlStateNormal];
    [self.decideButton setFaceColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateHighlighted];
    [self.decideButton setSideColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateNormal];
    [self.decideButton setSideColor:[UIColor colorWithHexadecimal:0xc0392bff] forState:UIControlStateHighlighted];
    [self.decideButton setTitle:NSLocalizedString(@"Decide", @"決定") forState:UIControlStateNormal];
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
        [cell setDelegate:self];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBRSSDiscoverTableViewCell *cell = (JBRSSDiscoverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) { return; }
    JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:indexPath.row];
    if (discover == nil) { return; }
    discover.isSubscribing = !discover.isSubscribing;
    [cell setDiscover:discover];
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}


#pragma mark - JBRSSDiscoverTableViewCell
- (void)ratingButtonDidTouchedUpInsideWithCell:(JBRSSDiscoverTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath == nil) { return; }
    JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:indexPath.row];
    if (discover == nil) { return; }

    JBRSSFeedRatingPopupViewController *vc = [[JBRSSFeedRatingPopupViewController alloc] initWithNibName:NSStringFromClass([JBRSSFeedRatingPopupViewController class])
                                                                                                  bundle:nil];
    [vc presentPopupAnimated:NO];
    [vc setFrameFromCell:cell
               tableView:self.tableView];
    [vc setDelegate:self];
    [vc setRow:indexPath.row];
    [vc setRating:discover.rating];
}


#pragma mark - JBRSSFeedRatingPopupViewControllerDelegate
- (void)feedRatingDidFinishedWithRating:(NSInteger)rating
                                    row:(NSInteger)row
          feedRatingPopupViewController:(JBRSSFeedRatingPopupViewController *)RSSFeedRatingPopupViewController
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                inSection:0];
    JBRSSDiscoverTableViewCell *cell = (JBRSSDiscoverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:indexPath.row];
    if (discover) {
        [discover setRating:rating];
        if (cell) {
            [cell setDiscover:discover];
        }
    }
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
    CGRect rect = CGRectMake(
            0, self.contentView.frame.origin.y,
            self.view.frame.size.width, self.contentView.frame.size.height
    );
    if (CGRectContainsPoint(rect, touchPos) == NO) {
        [self dismissPopup];
    }
}


@end

