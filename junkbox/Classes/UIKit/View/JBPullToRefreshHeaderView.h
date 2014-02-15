#pragma mark - constant
/// PullToRefreshの状態
typedef NS_ENUM(NSInteger, kJBPullToRefreshHeaderViewState) {
    kJBPullToRefreshHeaderViewStateHidden,
    kJBPullToRefreshHeaderViewStatePullingDown,
    kJBPullToRefreshHeaderViewStateOveredThreshold,
    kJBPullToRefreshHeaderViewStateStopping
};
#define kJBPullToRefreshHeaderViewMargin 10.0f;
/// WebViewをフリックしたあと引っ込むアニメーションの時間
#define kJBPullToRefreshHeaderViewDurationOfFlickAnimation 0.25f


#pragma mark - class
@class JBPullToRefreshHeaderView;


#pragma mark - JBPullToRefreshHeaderViewDelegate
/// JBPullToRefreshHeaderViewDelegate
@protocol JBPullToRefreshHeaderViewDelegate <NSObject>


/**
 * ScrollViewがPullされた
 */
- (void)scrollViewDidPulled;



@end


#pragma mark - JBPullToRefreshHeaderView
/// Pull To Refresh UI
@interface JBPullToRefreshHeaderView : UIView {
}


#pragma mark - property
/// PullToRefreshするScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 矢印
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
/// インジケーター
@property (nonatomic, weak) IBOutlet UIImageView *indicatorImageView;
/// delegate
@property (nonatomic, weak) IBOutlet id<JBPullToRefreshHeaderViewDelegate> delegate;
/// PullToRefreshの状態
@property (nonatomic, assign) kJBPullToRefreshHeaderViewState state;
/// 直前までのScrollViewy座標位置
@property (nonatomic, assign) CGFloat previousContentOffsetYOfScrollView;


#pragma mark - api
/**
 * Refresh終了
 */
- (void)finishRefreshing;

/**
 * Refresh終了
 * @param animated animated
 */
- (void)finishRefreshingWithAnimated:(BOOL)animated;

- (void)scrollViewDidScroll:(UIScrollView *)s;

- (void)scrollViewDidEndDragging:(UIScrollView *)s
                  willDecelerate:(BOOL)decelerate;


@end

/*
- (void)loadView
{
    [super loadView];
    [self.pullToRefreshHeaderView setDelegate:self];
    [self.pullToRefreshHeaderView setScrollView:scrollView];

    ...
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pullToRefreshHeaderView finishRefreshing];
    ...
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullToRefreshHeaderView scrollViewDidScroll:scrollView];

    ...
}

- (void)scrollViewDidEndDragging:(UIScrollView *)s
                  willDecelerate:(BOOL)decelerate
{
    [self.pullToRefreshHeaderView scrollViewDidScroll:scrollView];

    ...
}

#pragma mark - JBPullToRefreshHeaderViewDelegate
- (void)scrollViewDidPulled
{
    ...
}
*/
