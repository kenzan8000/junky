#import "JBRSSFeedUnreadController.h"
#import "JBRSSFeedUnread.h"
#import "JBRSSPinList.h"
#import "JBWebViewController.h"
#import "JBBlinkView.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedTouchAllOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
/// UIKit-Extension
#import "UIBarButtonItem+Space.h"
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "DejalActivityView.h"
#import "IonIcons.h"
#import "Reachability.h"
/// Pods-Extension
#import "JBQBFlatButton.h"
#import "SSGentleAlertView+Junkbox.h"


#pragma mark - JBRSSFeedUnreadController
@implementation JBRSSFeedUnreadController


#pragma mark - synthesize
@synthesize unreadList;
@synthesize indexOfUnreadList;
@synthesize titleView;
@synthesize previousButton;
@synthesize nextButton;
@synthesize backButtonView;
@synthesize pinButtonView;
@synthesize indexOfUnreadListBackgroundView;
@synthesize indexOfUnreadListLabel;
@synthesize URLLabel;
@synthesize reloadButton;
@synthesize delegate;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.indexOfUnreadList = 0;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [self.unreadList setOperationQueuePriority:NSOperationQueuePriorityNormal];
    self.unreadList = nil;
    self.titleView = nil;
    self.backButtonView = nil;
    self.pinButtonView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    self.webView.scrollView.delegate = self;

    // ナビゲーションバー
        // タイトル
    self.titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    self.titleView.delegate = self;
    [self.titleView useButton];
    self.navigationItem.titleView = self.titleView;
        // 戻る
    self.backButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:nil/*NSLocalizedString(@"Back", @"戻る")*/
                                                                   icon:icon_arrow_left_c];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];
        // PINボタン
    self.pinButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                 title:nil//NSLocalizedString(@"Read Later", @"あとで読む")
                                                                  icon:icon_pin
                                                                 color:[UIColor colorWithHexadecimal:0xe04080ff]];
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.pinButtonView]]
                                       animated:NO];

    // ツールバー
    NSArray *buttons = @[self.previousButton, self.nextButton];
    NSArray *buttonTitles = @[icon_chevron_left, icon_chevron_right];
    for (NSInteger i = 0; i < buttons.count; i++) {
        [buttons[i] setFont:[IonIcons fontWithSize:20]];
        [buttons[i] setTitle:buttonTitles[i]
                    forState:UIControlStateNormal];
    }

    // WebView読み込み
    [self loadWebView];

    // 画面下のバーのレイアウト
    [self designPreviousAndNextButton];

    // 何件中何件
    [self setIndexOfUnreadListBackgroundViewPositionByScrollViewY];
    [self setIndexOfUnreadListWithIndex:self.indexOfUnreadList];

    // WebView位置調整
    CGFloat webViewOriginY = self.indexOfUnreadListBackgroundView.frame.size.height;
    CGFloat webViewBottomY = self.webView.frame.origin.y + self.webView.frame.size.height;
    [self.webView setFrame:CGRectMake(
        self.webView.frame.origin.x, webViewOriginY,
        self.webView.frame.size.width, webViewBottomY - webViewOriginY
    )];

    // 記事一覧読み込み失敗時のリロードボタン
    [self.reloadButton setImage:[IonIcons imageWithIcon:icon_refresh
                                                   size:28
                                                  color:[UIColor whiteColor]]
                       forState:UIControlStateNormal];
    self.reloadButton.margin = 2.0f;
    self.reloadButton.depth = 2.0f;
    [self.reloadButton setFaceColor:[UIColor colorWithHexadecimal:0x7f8c8dff]
                           forState:UIControlStateNormal];
    [self.reloadButton setFaceColor:[UIColor colorWithHexadecimal:0x687378ff]
                           forState:UIControlStateHighlighted];
    [self.reloadButton setSideColor:[UIColor colorWithHexadecimal:0x687378ff]
                           forState:UIControlStateNormal];
    [self.reloadButton setSideColor:[UIColor colorWithHexadecimal:0x505a5fff]
                           forState:UIControlStateHighlighted];
    [self.reloadButton setHidden:YES];

    // unread listの読み込みが失敗していた場合
    if (self.unreadList.isFailedLoad) {
        [self.titleView setTitle:NSLocalizedString(@"Getting Unread Article Failed", @"未読の記事取得に失敗しました")];
        [self.reloadButton setHidden:NO];
    }
    // unread listの読み込みがまだ && 読み込み中
    else if (self.unreadList.count == 0 && [self.unreadList isFinishedLoading] == NO) {
        [self.reloadButton setHidden:YES];
        [self.unreadList setListDelegate:self];
        [self.unreadList setOperationQueuePriority:NSOperationQueuePriorityVeryHigh];
        [DejalActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading...", @"読み込み中")];
    }
    // 既読 or 未読0件
    else {
        if ([self.unreadList isFinishedLoading]) {
            [self.titleView setTitle:NSLocalizedString(@"No Unread Article", @"未読の記事がありません")];
        }
        // 既読
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(feedWillTouchAllWithRSSFeedUnreadController:)]) {
            [self.delegate feedWillTouchAllWithRSSFeedUnreadController:self];
            [self touchAllToWebAPI];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pinButtonView setBadgeText:[@([[JBRSSPinList sharedInstance] count]) stringValue]
                               color:[UIColor colorWithHexadecimal:0xaaaaaaff]];
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


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:self.webView
shouldStartLoadWithRequest:request
    navigationType:navigationType];

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self openURL:request.URL];
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [super webViewDidStartLoad:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:self.webView];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [super webView:self.webView
didFailLoadWithError:error];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setIndexOfUnreadListBackgroundViewPositionByScrollViewY];
}


#pragma mark - JBRSSFeedUnreadListDelegate
- (void)unreadListDidFinishLoadWithList:(JBRSSFeedUnreadList *)list
{
    // アニメーション終了
    [DejalActivityView removeView];

    // 既読だった場合
    if (self.unreadList.count == 0) {
        [self.titleView setTitle:NSLocalizedString(@"No Unread Article", @"未読の記事がありません")];
        return;
    }

    // 記事表示
    [self loadWebView];

    // 画面下のバーのレイアウト
    [self designPreviousAndNextButton];

    // 何件中何件
    [self setIndexOfUnreadListBackgroundViewPositionByScrollViewY];
    [self setIndexOfUnreadListWithIndex:self.indexOfUnreadList];

    // 既読
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(feedWillTouchAllWithRSSFeedUnreadController:)]) {
        [self.delegate feedWillTouchAllWithRSSFeedUnreadController:self];
        [self touchAllToWebAPI];
    }
}

- (void)unreadListDidFailLoadWithError:(NSError *)error
{
    [DejalActivityView removeView];
    [self.reloadButton setHidden:NO];
    // エラー処理
         // 401
    if (error.code == http::statusCode::UNAUTHORIZED) {
    }
    else {
        [self.titleView setTitle:NSLocalizedString(@"Getting Unread Article Failed", @"未読の記事取得に失敗しました")];
    }
}


#pragma mark - JBNavigationBarTitleViewDelegate
/**
 * タイトルボタン押下
 * @param titleView titleView
 */
- (void)touchedUpInsideTitleButtonWithNavigationBarTitleViewDelegate:(JBNavigationBarTitleView *)titleView
{
    JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
    if (unread) {
        [self openURL:unread.link];
    }
}


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    // 戻る
    if (barButtonView == self.backButtonView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // PIN
    else if (barButtonView == self.pinButtonView) {
        JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
        if (unread == nil) { return; }
        [[JBRSSPinList sharedInstance] addPinWithTitle:unread.title
                                                  link:[unread.link absoluteString]];
        // 数字が変わったのを体感しやすくするため、遅延させている
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.2), dispatch_get_main_queue(), ^ () {
            [weakSelf.pinButtonView setBadgeText:[@([[JBRSSPinList sharedInstance] count]) stringValue]
                                           color:[UIColor colorWithHexadecimal:0xaaaaaaff]];
        });
        // ステータスバー
        [[MTStatusBarOverlay sharedInstance] postFinishMessage:NSLocalizedString(@"Added Read Later", @"あとで読むページを追加しました")
                                                      duration:2.5f];
    }
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithPreviousButton:(UIButton *)button
{
    // 点滅
    if (self.unreadList && self.indexOfUnreadList - 1 < 0) {
        [JBBlinkView showBlinkWithColor:[UIColor colorWithHexadecimal:0xffffff40]
                                  count:1
                               interval:0.08f];
    }

    // 見た目調整
    NSInteger previousIndex = self.indexOfUnreadList;
    [self setIndexOfUnreadListWithIndex:self.indexOfUnreadList-1];
    if (previousIndex != self.indexOfUnreadList) { [self loadWebView]; }
    [self designPreviousAndNextButton];
    [self setIndexOfUnreadListBackgroundViewPositionByScrollViewY];
}

- (IBAction)touchedUpInsideWithNextButton:(UIButton *)button
{
    // 点滅
    if (self.unreadList && self.indexOfUnreadList + 1 >= self.unreadList.count) {
        [JBBlinkView showBlinkWithColor:[UIColor colorWithHexadecimal:0xffffff60]
                                  count:1
                               interval:0.1f];
    }

    // 見た目調整
    NSInteger previousIndex = self.indexOfUnreadList;
    [self setIndexOfUnreadListWithIndex:self.indexOfUnreadList+1];
    if (previousIndex != self.indexOfUnreadList) { [self loadWebView]; }
    [self designPreviousAndNextButton];
    [self setIndexOfUnreadListBackgroundViewPositionByScrollViewY];
}

- (IBAction)touchedUpInsideWithReloadButton:(UIButton *)button
{
    if ([[Reachability reachabilityForInternetConnection] isReachable] == NO) {
        [SSGentleAlertView showWithMessage:NSLocalizedString(@"Cannot access the Network.", @"not reachable")
                              buttonTitles:@[NSLocalizedString(@"Confirm", @"確認")]
                                  delegate:nil];
        return;
    }

    [self.unreadList loadFeedFromWebAPI];
    [self.reloadButton setHidden:YES];
    [self.unreadList setListDelegate:self];
    [self.unreadList setOperationQueuePriority:NSOperationQueuePriorityVeryHigh];
    [DejalActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading...", @"読み込み中")];
}

- (void)scrollViewDidPulled
{
    [self loadWebView];
}


#pragma mark - api
- (void)loadWebView
{
    JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
    if (unread) {
        [self.titleView setTitle:unread.title];
        [self.webView loadHTMLString:unread.body
                             baseURL:unread.link];
    }
}


#pragma mark - private api
/**
 * 次の記事へ、前の記事へボタンデザイン
 */
- (void)designPreviousAndNextButton
{
    UIColor *defaultColor = [UIColor colorWithHexadecimal:0x4b96ffff];
    UIColor *cornerColor = [UIColor colorWithHexadecimal:0xaaaaaaff];
    if (self.unreadList == nil || [self.unreadList count] == 0) {
        [self.previousButton setTitleColor:cornerColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:cornerColor forState:UIControlStateNormal];
    }
    else if (self.indexOfUnreadList <= 0) {
        [self.previousButton setTitleColor:cornerColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:(([self.unreadList count] <= 1) ? cornerColor : defaultColor) forState:UIControlStateNormal];
    }
    else if (self.indexOfUnreadList >= [self.unreadList count]-1) {
        [self.previousButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:cornerColor forState:UIControlStateNormal];
    }
    else {
        [self.previousButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [self.nextButton setTitleColor:defaultColor forState:UIControlStateNormal];
    }
}

/**
 * 外部リンクを押して、Webを開くときの挙動
 * @param URL URL
 */
- (void)openURL:(NSURL *)URL
{
    // 遷移
    JBWebViewController *vc = [[JBWebViewController alloc] initWithNibName:NSStringFromClass([JBWebViewController class])
                                                                    bundle:nil];
    [vc setInitialURL:URL];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

/**
 * リストの何件中何件の記事を表示しているかセット
 */
- (void)setIndexOfUnreadListWithIndex:(NSInteger)index
{
    self.indexOfUnreadList = index;
    if (self.indexOfUnreadList >= [self.unreadList count]) {self.indexOfUnreadList = [self.unreadList count]-1; }
    if (self.indexOfUnreadList < 0) { self.indexOfUnreadList = 0; }

    if (self.unreadList) {
        NSInteger i = (self.unreadList.count > 0) ? self.indexOfUnreadList+1 : 0;
        [self.indexOfUnreadListLabel setText:[NSString stringWithFormat:@"%d / %d", i, self.unreadList.count]];
    }
    else {
        [self.indexOfUnreadListLabel setText:@""];
    }
    if (self.unreadList) {
        JBRSSFeedUnread *unread = [self.unreadList unreadWithIndex:self.indexOfUnreadList];
        [self.URLLabel setText:(unread) ? [unread.link absoluteString] : @""];
    }
    else {
        [self.URLLabel setText:@""];
    }
}

/**
 * scrollViewの位置によってindexOfUnreadListBackgroundViewの位置を変える
 */
- (void)setIndexOfUnreadListBackgroundViewPositionByScrollViewY
{
    CGFloat paddingY = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat scrollOffset = paddingY + self.webView.scrollView.contentOffset.y;
    if (scrollOffset > 0) {
        paddingY -= scrollOffset;
    }
    [self.indexOfUnreadListBackgroundView setFrame:CGRectMake(
        self.indexOfUnreadListBackgroundView.frame.origin.x, paddingY,
        self.indexOfUnreadListBackgroundView.frame.size.width, self.indexOfUnreadListBackgroundView.frame.size.height
    )];
}

/**
 * フィードを既読化
 */
- (void)touchAllToWebAPI
{
    JBRSSFeedTouchAllOperation *operation = [[JBRSSFeedTouchAllOperation alloc] initWithHandler:
        ^ (NSHTTPURLResponse *response, id object, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }
                                                                                    subscribeId:self.unreadList.subscribeId
    ];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}


@end
