#import <QuartzCore/QuartzCore.h>
#import "JBRSSDiscover.h"
#import "JBRSSDiscoverPopupViewController.h"
#import "JBRSSFeedSubscribeOperation.h"
#import "JBRSSFeedSetRateOperation.h"
#import "JBRSSOperationQueue.h"
// Pods
#import "MTStatusBarOverlay.h"
// Pods-Extension
#import "JBQBFlatButton.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
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
    [vc setRating:discover.rate];
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
        [discover setRate:rating];
        if (cell) {
            [cell setDiscover:discover];
        }
    }
}


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    [self subscribeToWeb];
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

/**
 * フィードの登録、レイティングをする
 */
- (void)subscribeToWeb
{
        // 登録するフィードがあるかどうか
    BOOL isSubscribing = NO;
        // 登録するフィードのindex(start->最も先頭、end->最も後ろ)
    NSInteger start = self.feedList.count-1, end = 0;
    for (NSInteger i = 0; i < self.feedList.count; i++) {
        JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:i];
        isSubscribing = isSubscribing || discover.isSubscribing;
        if (discover.isSubscribing) {
            if (start < i) { start = i; }
            if (end > i) { end = i; }
        }
    }
    if (isSubscribing == NO) { return; }

    // ステータスバー
    [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Adding RSS Feed...", @"RSSフィードを登録しています...")
                                            animated:YES];

    // 登録
    for (NSInteger i = 0; i < self.feedList.count; i++) {
        JBRSSDiscover *discover = (JBRSSDiscover *)[self.feedList objectAtIndex:i];
        BOOL isStart = (i == start);
        BOOL isEnd = (i == end);
        [[JBRSSOperationQueue defaultQueue] addOperation:[self subscribeOperationWithFeedlink:discover.feedlink
                                                                                      isStart:isStart]];
        [[JBRSSOperationQueue defaultQueue] addOperation:[self setRateOperationWithSubscribeId:discover.subscribeId
                                                                                          rate:@(discover.rate)
                                                                                         isEnd:isEnd]];
    }
}

/**
 * フィード登録処理
 * @param feedlink feedlink
 * @param isStart 最初のリクエストかどうか
 * @return ISOperation
 */
- (JBRSSFeedSubscribeOperation *)subscribeOperationWithFeedlink:(NSURL *)feedlink
                                                        isStart:(BOOL)isStart
{
    JBRSSFeedSubscribeOperation *operation = nil;
    if (isStart) {
        operation = [[JBRSSFeedSubscribeOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            // 失敗
            if (error || [JSON[@"isSuccess"] boolValue] == NO) {
                // ステータスバー
                dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"Failed Adding RSS Feed", @"RSSフィードの登録に失敗しました")
                                                                      duration:2.5f
                                                                      animated:YES];
                });
            }
        }
                                                                     URL:feedlink
        ];
    }
    else {
        operation = [[JBRSSFeedSubscribeOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            // 失敗
            if (error || [JSON[@"isSuccess"] boolValue] == NO) {
                // ステータスバー
                dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"Failed Adding RSS Feed", @"RSSフィードの登録に失敗しました")
                                                                      duration:2.5f
                                                                      animated:YES];
                });
            }
        }
                                                                     URL:feedlink
        ];
    }
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    return operation;
}

/**
 * フィードレイティング処理
 * @param subscribeId subscribeId
 * @param rate rate
 * @param isEnd 最後のリクエストかどうか
 * @return ISOperation
 */
- (JBRSSFeedSetRateOperation *)setRateOperationWithSubscribeId:(NSString *)subscribeId
                                            rate:(NSNumber *)rate
                                           isEnd:(BOOL)isEnd
{
    JBRSSFeedSetRateOperation *operation = nil;
    if (isEnd) {
        operation = [[JBRSSFeedSetRateOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            // 成功
            if (error == nil &&  [JSON[@"isSuccess"] boolValue]) {
                // ステータスバー
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^ () {
                    [[MTStatusBarOverlay sharedInstance] hide];
                });
            }
            // 失敗
            else {
                // ステータスバー
                dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"Failed Adding RSS Feed", @"RSSフィードの登録に失敗しました")
                                                                      duration:2.5f
                                                                      animated:YES];
                });
            }

        }
                                                           subscribeId:subscribeId
                                                                  rate:rate
        ];
    }
    else {
        operation = [[JBRSSFeedSetRateOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            // 失敗
            if (error || [JSON[@"isSuccess"] boolValue] == NO) {
                // ステータスバー
                dispatch_async(dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"Failed Adding RSS Feed", @"RSSフィードの登録に失敗しました")
                                                                      duration:2.5f
                                                                      animated:YES];
                });
            }
        }
                                                           subscribeId:subscribeId
                                                                  rate:rate
        ];
    }
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    return operation;
}


@end
