#import "AppDelegate.h"
#import "JBSidebarMenu.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedDiscoverOperation.h"
#import "JBRSSDiscoverPopupViewController.h"
#import "JBRSSPinList.h"
#import "JBRSSConstant.h"
#import "JBRSSLogin.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"
/// Pods
#import "HTBHatenaBookmarkManager.h"
#import "MTStatusBarOverlay.h"
#import "IonIcons.h"


#pragma mark - JBSidebarMenu
@implementation JBSidebarMenu


#pragma mark - synthesize
@synthesize sidebar;
@synthesize type;
@synthesize webURL;
@synthesize webTitle;
@synthesize delegate;


#pragma mark - initializer
- (id)initWithSidebarType:(JBSidebarMenuType)t
{
    self = [super init];
    if (self) {
        self.type = t;
        BOOL hatebuIsAuthorized = [HTBHatenaBookmarkManager sharedManager].authorized;
        BOOL ldrIsAuthorized = [[JBRSSLogin sharedInstance] authorized];
        if (hatebuIsAuthorized == NO && ldrIsAuthorized == NO) {
            self.type = JBSidebarMenuTypeNone;
        }
        else if (hatebuIsAuthorized == NO) {
            self.type = JBSidebarMenuTypeRSS;
        }
        else if (ldrIsAuthorized == NO) {
            self.type = JBSidebarMenuTypeBookmark;
        }

        [self initializeSidebar];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.delegate = nil;
    self.webURL = nil;
    self.webTitle = nil;
    self.sidebar = nil;
}


#pragma mark - RNFrostedSidebarDelegate
- (void)sidebar:(RNFrostedSidebar *)sidebar
willShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
}

- (void)sidebar:(RNFrostedSidebar *)sidebar
didShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
}

- (void)sidebar:(RNFrostedSidebar *)sidebar
willDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
}

- (void)sidebar:(RNFrostedSidebar *)sidebar
didDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
}

- (void)sidebar:(RNFrostedSidebar *)sidebar
didTapItemAtIndex:(NSUInteger)index
{
    [self touchedUpInsideWithIndex:index];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar
      didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index
{
}


#pragma mark - api
- (void)show
{
    [self.sidebar show];
}


#pragma mark - private api
/**
 * サイドバー生成
 */
- (void)initializeSidebar
{
    NSArray *images = @[];
    if (self.type == JBSidebarMenuTypeDefault) {
        /* ******************************
         * RSS PIN
         * SOCIAL BOOKMARK
         * ADD RSS FEED
         * OPEN BROWSER
         ***************************** */
        images = @[
            [IonIcons imageWithIcon:icon_pin size:75 color:[UIColor colorWithHexadecimal:0xff6c5cff]],
            [IonIcons imageWithIcon:icon_ios7_bookmarks size:75 color:[UIColor colorWithHexadecimal:0x54b8fbff]],
            [IonIcons imageWithIcon:icon_social_rss size:75 color:[UIColor colorWithHexadecimal:0xff9e42ff]],
            [IonIcons imageWithIcon:icon_ios7_browsers size:75 color:[UIColor colorWithHexadecimal:0x7f8c8dff]],
        ];
    }
    else if (self.type == JBSidebarMenuTypeRSS) {
        /* ******************************
         * RSS PIN
         * ADD RSS FEED
         * OPEN BROWSER
         ***************************** */
        images = @[
            [IonIcons imageWithIcon:icon_pin size:75 color:[UIColor colorWithHexadecimal:0xff6c5cff]],
            [IonIcons imageWithIcon:icon_social_rss size:75 color:[UIColor colorWithHexadecimal:0xff9e42ff]],
            [IonIcons imageWithIcon:icon_ios7_browsers size:75 color:[UIColor colorWithHexadecimal:0x7f8c8dff]],
        ];
    }
    else if (self.type == JBSidebarMenuTypeBookmark) {
        /* ******************************
         * SOCIAL BOOKMARK
         * OPEN BROWSER
         ***************************** */
        images = @[
            [IonIcons imageWithIcon:icon_ios7_bookmarks size:75 color:[UIColor colorWithHexadecimal:0x54b8fbff]],
            [IonIcons imageWithIcon:icon_ios7_browsers size:75 color:[UIColor colorWithHexadecimal:0x7f8c8dff]],
        ];
    }
    else {
        /* ******************************
         * OPEN BROWSER
         ***************************** */
        images = @[
            [IonIcons imageWithIcon:icon_ios7_browsers size:75 color:[UIColor colorWithHexadecimal:0x7f8c8dff]],
        ];
    }

    self.sidebar = [[RNFrostedSidebar alloc] initWithImages:images];
    [self.sidebar setTintColor:[UIColor colorWithHexadecimal:0x95a5a6a0]];
    [self.sidebar setItemBackgroundColor:[UIColor colorWithHexadecimal:0xecf0f1ff]];
    [self.sidebar setShowFromRight:YES];
    [self.sidebar setDelegate:self];
}

/**
 * JBSidebarMenuTypeDefaultの時、タップイベントハンドリング
 * @param index index
 */
- (void)touchedUpInsideWithIndex:(NSInteger)index
{
    [self.sidebar dismiss];

    if (self.type == JBSidebarMenuTypeDefault) {
        switch (index) {
            case 0:
                [self addPin];
                break;
            case 1:
                [self addBookmark];
                break;
            case 2:
                [self discoverFeed];
                break;
            case 3:
                if ([[UIApplication sharedApplication] canOpenURL:self.webURL]) {
                    [[UIApplication sharedApplication] openURL:self.webURL];
                }
                break;
           default:
                break;
        }
    }
    else if (self.type == JBSidebarMenuTypeRSS) {
        switch (index) {
            case 0:
                [self addPin];
                break;
            case 1:
                [self discoverFeed];
                break;
            case 2:
                if ([[UIApplication sharedApplication] canOpenURL:self.webURL]) {
                    [[UIApplication sharedApplication] openURL:self.webURL];
                }
                break;
           default:
                break;
        }
    }
    else if (self.type == JBSidebarMenuTypeBookmark) {
        switch (index) {
            case 0:
                [self addBookmark];
                break;
            case 1:
                if ([[UIApplication sharedApplication] canOpenURL:self.webURL]) {
                    [[UIApplication sharedApplication] openURL:self.webURL];
                }
                break;
           default:
                break;
        }
    }
    else {
        switch (index) {
            case 0:
                if ([[UIApplication sharedApplication] canOpenURL:self.webURL]) {
                    [[UIApplication sharedApplication] openURL:self.webURL];
                }
                break;
           default:
                break;
        }
    }
}

#pragma mark - RSS Reader Add Pin
/**
 * ページをPINに追加する
 */
- (void)addPin
{
    [[JBRSSPinList sharedInstance] addPinWithTitle:self.webTitle
                                              link:[self.webURL absoluteString]];
    // ステータスバー
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:NSLocalizedString(@"Added Read Later", @"あとで読むページを追加しました")
                                                  duration:2.5f];
}


#pragma mark - Bookmark
/**
 * ページをBookmarkに追加する
 */
- (void)addBookmark
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(bookmarkWillStartWithSidebarMenu:URL:)]) {
        [self.delegate bookmarkWillStartWithSidebarMenu:self
                                                    URL:self.webURL];
    }
}


#pragma mark - RSS Reader Feed Discover and Add
/**
 * URLからRSS Feedを探す
 */
- (void)discoverFeed
{
    // ステータスバー
    dispatch_async(dispatch_get_main_queue(), ^ () {
        [[MTStatusBarOverlay sharedInstance] postMessage:NSLocalizedString(@"Discovering RSS Feed...", @"URLからRSS Feedを探しています...")
                                                animated:YES];
    });

    JBRSSFeedDiscoverOperation *operation = [[JBRSSFeedDiscoverOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error)
        {
            // 失敗
            if (error) {
                // ステータスバー
                dispatch_async(dispatch_get_main_queue(), ^ () {
                    [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:NSLocalizedString(@"Discovering RSS Feed failed", @"RSS Feedの探索に失敗しました")
                                                                           duration:2.5f
                                                                           animated:YES];
                });
                return;
            }

            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);

            // フィードが0件の場合
            if (JSON == nil || [JSON isKindOfClass:[NSArray class]] == NO || [JSON count] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^ () {
                    // ステータスバー
                    [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:NSLocalizedString(@"RSS Feed could not found", @"フィードが0件の場合")
                                                                          duration:2.0f
                                                                          animated:YES];
                });
                return;
            }

            // 成功
                // ステータスバー
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^ () {
                [[MTStatusBarOverlay sharedInstance] hide];
            });
                // ポップアップ
            dispatch_async(dispatch_get_main_queue(), ^ () {
                JBRSSDiscoverPopupViewController *vc = [[JBRSSDiscoverPopupViewController alloc] initWithNibName:NSStringFromClass([JBRSSDiscoverPopupViewController class])
                                                                                                    bundle:nil];
                [vc setJSON:JSON];
                [vc presentPopup];
            });
        }
                                                                                            URL:self.webURL
    ];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}


@end
