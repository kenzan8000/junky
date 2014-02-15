#import "JBPullToRefreshHeaderView.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBPullToRefreshHeaderView
@implementation JBPullToRefreshHeaderView


#pragma mark - synthesize
@synthesize scrollView = m_scrollView;
@synthesize arrowImageView;
@synthesize indicatorImageView;
@synthesize delegate;
@synthesize state = m_state;
@synthesize previousContentOffsetYOfScrollView;


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.state = kJBPullToRefreshHeaderViewStateHidden;
        self.previousContentOffsetYOfScrollView = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    self.state = kJBPullToRefreshHeaderViewStateHidden;
    self.previousContentOffsetYOfScrollView = 0;

    [self.arrowImageView setImage:[IonIcons imageWithIcon:icon_arrow_down_c
                                                     size:32
                                                    color:[UIColor grayColor]]];
    [self.indicatorImageView setImage:[IonIcons imageWithIcon:icon_load_c
                                                     size:32
                                                    color:[UIColor grayColor]]];
}


#pragma mark - release
- (void)dealloc
{
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        [((UITableView *)self.scrollView) setTableHeaderView:nil];
    }
    else {
        [self removeFromSuperview];
    }
    self.scrollView = nil;
}


#pragma mark - api
- (void)setScrollView:(UIScrollView *)s
{
    CGRect frame = self.frame;
    m_scrollView = s;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        frame.origin.y = 0;
        [((UITableView *)self.scrollView) setTableHeaderView:self];
    }
    else {
        frame.origin.y = -self.frame.size.height;
        [self.scrollView addSubview:self];
    }
    [self setFrame:frame];

    self.state = kJBPullToRefreshHeaderViewStateStopping;
}

- (void)setState:(kJBPullToRefreshHeaderViewState)s
{
    switch (s) {
        case kJBPullToRefreshHeaderViewStateHidden:
            [self stopIndicatorAnimating];
            self.arrowImageView.hidden = YES;
            break;

        case kJBPullToRefreshHeaderViewStatePullingDown:
            [self stopIndicatorAnimating];
            self.arrowImageView.hidden = NO;
            if (m_state != kJBPullToRefreshHeaderViewStatePullingDown) {
                [self animateForHeadingUp:NO];
            }
            break;
        case kJBPullToRefreshHeaderViewStateOveredThreshold:
            [self stopIndicatorAnimating];
            self.arrowImageView.hidden = NO;
            if (m_state == kJBPullToRefreshHeaderViewStatePullingDown) {
                [self animateForHeadingUp:YES];
            }
            break;
        case kJBPullToRefreshHeaderViewStateStopping:
            [self startIndicatorAnimating];
            self.arrowImageView.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidPulled)]) {
                [self.delegate scrollViewDidPulled];
            }
            break;
    }

    m_state = s;
}

- (void)finishRefreshing
{
    self.state = kJBPullToRefreshHeaderViewStateHidden;
    [self setHeaderViewHidden:YES
                     animated:YES];
}

- (void)finishRefreshingWithAnimated:(BOOL)animated
{
    self.state = kJBPullToRefreshHeaderViewStateHidden;
    [self setHeaderViewHidden:YES
                     animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)s
{
    CGFloat current = s.contentOffset.y;
    if (s.isDragging) {
        CGFloat threshold = self.frame.size.height;
        //指をはなすと更新
        if (current <= -threshold) {
            self.state = kJBPullToRefreshHeaderViewStateOveredThreshold;
        }
        //引き下げて...
        else if (current < 0) {
            self.state = kJBPullToRefreshHeaderViewStatePullingDown;
        }
        else {
            self.state = kJBPullToRefreshHeaderViewStateHidden;
        }
    }
    self.previousContentOffsetYOfScrollView = current;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)s
                  willDecelerate:(BOOL)decelerate
{
    if (self.state == kJBPullToRefreshHeaderViewStateOveredThreshold) {
        self.state = kJBPullToRefreshHeaderViewStateStopping;
        [self setHeaderViewHidden:NO
                         animated:YES];
    }
}


#pragma mark - private api
/**
 * 矢印アニメーション
 * @param headingUp 上に移動中かどうか
 */
- (void)animateForHeadingUp:(BOOL)headingUp
{
    CGFloat startAngle = headingUp ? 0 : M_PI + 0.00001;
    CGFloat endAngle = headingUp ? M_PI + 0.00001 : 0;

    self.arrowImageView.transform = CGAffineTransformMakeRotation(startAngle);
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^ () { weakSelf.arrowImageView.transform = CGAffineTransformMakeRotation(endAngle); }
                     completion:^ (BOOL finished) { }];
}

/**
 * 表示・非表示アニメーション
 * @param hidden 表示・非表示
 * @param animated アニメーションON,OFF
 */
- (void)setHeaderViewHidden:(BOOL)hidden
                   animated:(BOOL)animated
{
    CGFloat offset = kJBPullToRefreshHeaderViewMargin;
    if (hidden == NO) {
        offset = self.frame.size.height + kJBPullToRefreshHeaderViewMargin;
    }

    //animation
    CGFloat duration = (animated) ? kJBPullToRefreshHeaderViewDurationOfFlickAnimation : 0.0f;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ () {
        if (weakSelf.scrollView) {
            weakSelf.scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }
    }
                     completion: ^ (BOOL finished) {
        // Refresh
        if (finished && hidden == NO) {
        }
    }];
}

- (void)startIndicatorAnimating
{
    [self.indicatorImageView setHidden:NO];

    CALayer *layer = self.indicatorImageView.layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    animation.toValue = [NSNumber numberWithFloat:M_PI / 2.0];
    animation.duration = 0.25;
    animation.repeatCount = MAXFLOAT;
    animation.cumulative = YES;

    NSString *key = [NSString stringWithFormat:@"%@.Transform.Rotation", NSStringFromClass([JBPullToRefreshHeaderView class])];
    [layer addAnimation:animation
                 forKey:key];
}

- (void)stopIndicatorAnimating
{
    [self.indicatorImageView setHidden:YES];

    CALayer *layer = self.indicatorImageView.layer;
    NSString *key = [NSString stringWithFormat:@"%@.Transform.Rotation", NSStringFromClass([JBPullToRefreshHeaderView class])];
    [layer removeAnimationForKey:key];
}

@end
