#import "AppDelegate.h"
#import "JBSidebarMenu.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSFeedDiscoverOperation.h"
#import "JBRSSDiscoverPopupViewController.h"
#import "JBRSSPinList.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"
/// Pods
#import "MTStatusBarOverlay.h"
#import "IonIcons.h"


#pragma mark - JBSidebarMenu
@implementation JBSidebarMenu


#pragma mark - synthesize
@synthesize sidebar;
@synthesize type;
@synthesize webURL;
@synthesize webTitle;


#pragma mark - initializer
- (id)initWithSidebarType:(JBSidebarMenuType)t
{
    self = [super init];
    if (self) {
        self.type = t;
        [self initializeSidebar];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
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
    if (self.type == JBSidebarMenuTypeDefault) {
        [self touchedUpInsideTypeDefaultAtIndex:index];
    }
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
            [IonIcons imageWithIcon:icon_pin size:75 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_ios7_bookmarks size:75 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_social_rss size:75 color:[UIColor colorWithHexadecimal:0xffffffff]],
            [IonIcons imageWithIcon:icon_ios7_browsers size:75 color:[UIColor colorWithHexadecimal:0xffffffff]],
        ];
    }

    self.sidebar = [[RNFrostedSidebar alloc] initWithImages:images];
    [self.sidebar setShowFromRight:YES];
    [self.sidebar setDelegate:self];
}

/**
 * JBSidebarMenuTypeDefaultの時、タップイベントハンドリング
 * @param index index
 */
- (void)touchedUpInsideTypeDefaultAtIndex:(NSInteger)index
{
    [self.sidebar dismiss];

    switch (index) {
        case 0:// LivedoorReader Adding PIN
            [[JBRSSPinList sharedInstance] addPinWithTitle:self.webTitle
                                                      link:[self.webURL absoluteString]];
            // ステータスバー
            [[MTStatusBarOverlay sharedInstance] postFinishMessage:NSLocalizedString(@"Added Read Later", @"あとで読むページを追加しました")
                                                          duration:1.5f];
            break;
        case 1:// SOCIAL BOOKMARK
            break;
        case 2:// ADD RSS FEED
            [self discoverFeed];
            break;
        case 3:// OPEN BROWSER
            if ([[UIApplication sharedApplication] canOpenURL:self.webURL]) {
                [[UIApplication sharedApplication] openURL:self.webURL];
            }
            break;
       default:
            break;
    }
}


#pragma mark - LivedoorReader Feed Discover and Add
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
                    [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:NSLocalizedString(@"Discovering RSS Feed Failed", @"RSS Feedの探索に失敗しました")
                                                                           duration:1.5f
                                                                           animated:YES];
                });
                return;
            }

            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);

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
