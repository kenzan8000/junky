#import "JBRSSDiscoverTableViewCell.h"
#import "JBRSSDiscover.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"
#import "NKToggleOverlayButton.h"


#pragma mark - JBRSSDiscoverTableViewCell
@implementation JBRSSDiscoverTableViewCell


#pragma mark - synthesize
@synthesize titleLabel;
@synthesize subscribersCountLabel;
@synthesize linkLabel;
@synthesize subscribeButtonView;
@synthesize subscribeButton;


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [self.subscribeButton removeFromSuperview];
    self.subscribeButtonView = nil;
}


#pragma mark - event listner


#pragma mark - api
- (void)setDiscover:(JBRSSDiscover *)discover
{
    // ボタン
    self.subscribeButton = [NKToggleOverlayButton new];
    self.subscribeButton.frame = CGRectMake(
        0, 0,
        self.subscribeButtonView.frame.size.width, self.subscribeButtonView.frame.size.height
    );
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:24
                                                       color:[UIColor colorWithHexadecimal:0x34495eff]]
                            forState:UIControlStateNormal];
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:24
                                                       color:[UIColor colorWithHexadecimal:0x2c3e50ff]]
                            forState:UIControlStateHighlighted];
    [self.subscribeButton setOffImage:[UIImage imageNamed:kImageCommonClear]
                             forState:UIControlStateNormal];
    [self.subscribeButton setOffImage:[UIImage imageNamed:kImageCommonClear]
                             forState:UIControlStateHighlighted];
    self.subscribeButton.toggleOnBlock = ^(NKToggleOverlayButton *button) {
    };
    self.subscribeButton.toggleOffBlock = ^(NKToggleOverlayButton *button) {
    };
    [self.subscribeButton setShowOverlay:NO];
    [self.subscribeButton setIsOn:YES];
    [self.subscribeButtonView addSubview:self.subscribeButton];
    [self.subscribeButtonView.layer setBorderColor:[[UIColor colorWithHexadecimal:0x7f8c8dff] CGColor]];
    [self.subscribeButtonView.layer setBorderWidth:1.0f];
//NSLocalizedString(@"Subscribe", @"購読する")
//NSLocalizedString(@"Unsubscribe", @"購読をやめる")

    // ラベル
    [self.titleLabel setText:discover.title];
    [self.subscribersCountLabel setText:
        [NSString stringWithFormat:@"%d %@", discover.subscribersCount, NSLocalizedString(@"users", @"users")]
    ];
    [self.linkLabel setText:[discover.feedlink absoluteString]];
}


@end
