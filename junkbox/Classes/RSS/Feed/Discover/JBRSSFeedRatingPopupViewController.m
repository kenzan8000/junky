#import <QuartzCore/QuartzCore.h>
#import "JBRSSFeedRatingPopupViewController.h"
#import "JBOutlineLabel.h"
// Pods
#import "IonIcons.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"


#pragma mark - JBRSSFeedRatingPopupViewController
@implementation JBRSSFeedRatingPopupViewController


#pragma mark - synthesize
@synthesize contentView;
@synthesize ratingControl;
@synthesize closeButton;
@synthesize center;
@synthesize rating;
@synthesize row;
@synthesize delegate;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.center = CGPointZero;
        self.rating = 0;
        self.row = 0;
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

    UIImage *image = nil;

    // ポップアップView
    self.contentView.center = self.center;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = true;
    [self.contentView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.contentView.layer setBorderWidth:1.0f];

    // 閉じるボタン
    image = [IonIcons imageWithIcon:icon_close_round
                               size:24
                              color:[UIColor grayColor]];
    [self.closeButton setImage:image
                      forState:UIControlStateNormal];

    // レイティング
    JBOutlineLabel *outlineLabel = [JBOutlineLabel new];
    [outlineLabel setFrame:CGRectMake(10, 10, 32.0f, 32.0f)];
    [outlineLabel setTextColor:[UIColor colorWithHexadecimal:0xf1c40fff]];
    [outlineLabel setOutlineColor:[UIColor colorWithHexadecimal:0xbdc3c7ff]];
    [outlineLabel setOutlineWidth:1.2f];
    [outlineLabel setBackgroundColor:[UIColor clearColor]];
    [outlineLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:28.0f]];

    [outlineLabel setText:@"☆"];
    image = [outlineLabel image];
    self.ratingControl.starImage = image;

    [outlineLabel setText:@"★"];
    image = [outlineLabel image];
    self.ratingControl.starHighlightedImage = image;

    self.ratingControl.maxRating = 5;
    self.ratingControl.displayMode = EDStarRatingDisplayFull;
    self.ratingControl.delegate = self;
    self.ratingControl.horizontalMargin = 12;
    self.ratingControl.editable = YES;
    [self.ratingControl setRating:self.rating];
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


#pragma mark - EDStarRatingProtocol
-(void)starsSelectionChanged:(EDStarRating *)control
                      rating:(float)r
{
    self.rating = (NSInteger)r;
}


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    if (button == self.closeButton) {
        [self dismiss];
    }
}


#pragma mark - api
- (void)setFrameFromCell:(UITableViewCell *)cell
               tableView:(UITableView *)tableView
{
    CGPoint tableViewOrigin = [self absoluteOriginWithView:tableView];
    CGPoint cellCenter = CGPointMake(
        tableViewOrigin.x + cell.frame.origin.x - tableView.contentOffset.x + cell.frame.size.width / 2.0f,
        tableViewOrigin.y + cell.frame.origin.y - tableView.contentOffset.y + cell.frame.size.height / 2.0f
    );
    self.center = cellCenter;
}


#pragma mark - private api
- (void)touchesBegan:(NSSet*)touches
           withEvent:(UIEvent*)event
{
    CGPoint touchPos = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.contentView.frame, touchPos) == NO) {
        [self dismiss];
    }
}

/**
 * viewのcenterの絶対座標を求める
 * @param view view
 */
- (CGPoint)absoluteOriginWithView:(UIView *)v
{
    CGPoint offset = CGPointZero;
    if (v.superview != nil) {
        offset = [self absoluteOriginWithView:v.superview];
    }
    return CGPointMake(v.frame.origin.x + offset.x, v.frame.origin.y + offset.y);
}

/**
 * 非表示
 */
- (void)dismiss
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedRatingDidFinishedWithRating:row:feedRatingPopupViewController:)]) {
        [self.delegate feedRatingDidFinishedWithRating:self.rating
                                                   row:self.row
                         feedRatingPopupViewController:self];
    }
    // Dismiss
    [self dismissPopup];
}


@end
