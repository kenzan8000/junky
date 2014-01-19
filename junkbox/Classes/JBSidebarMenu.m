#import "JBSidebarMenu.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"
/// Pods
#import "IonIcons.h"


#pragma mark - JBSidebarMenu
@implementation JBSidebarMenu


#pragma mark - synthesize
@synthesize sidebar;
@synthesize type;
@synthesize openingURL;


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
    self.openingURL = nil;
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
        case 0:// RSS PIN
            break;
        case 1:// SOCIAL BOOKMARK
            break;
        case 2:// ADD RSS FEED
            break;
        case 3:// OPEN BROWSER
            if ([[UIApplication sharedApplication] canOpenURL:self.openingURL]) {
                [[UIApplication sharedApplication] openURL:self.openingURL];
            }
            break;
       default:
            break;
    }
}


@end
