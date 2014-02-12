#import "JBRSSDiscoverTableViewCell.h"
#import "JBRSSDiscover.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"
#import "NKToggleOverlayButton.h"


#pragma mark - NKToggleOverlayButton
@interface NKToggleOverlayButton()

- (void)toggle:(UITapGestureRecognizer *)recognizer;

@end


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
- (void)toggleIsOn
{
    [self.subscribeButton toggle:nil];
}

- (void)setDiscover:(JBRSSDiscover *)discover
{
    // ボタン
    self.subscribeButton = [NKToggleOverlayButton new];
        // 画像
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:44
                                                       color:[UIColor colorWithHexadecimal:0x34495eff]]
                            forState:UIControlStateNormal];
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:44
                                                       color:[UIColor colorWithHexadecimal:0x2c3e50ff]]
                            forState:UIControlStateHighlighted];
    [self.subscribeButton setOffImage:[UIImage imageNamed:kImageCommonClear]
                             forState:UIControlStateNormal];
    [self.subscribeButton setOffImage:[UIImage imageNamed:kImageCommonClear]
                             forState:UIControlStateHighlighted];
        // イベント
    self.subscribeButton.toggleOnBlock = ^(NKToggleOverlayButton *button) {
    };
    self.subscribeButton.toggleOffBlock = ^(NKToggleOverlayButton *button) {
    };
        // 設定
    [self.subscribeButton setShowOverlay:NO];
    [self.subscribeButton setIsOn:YES];
    [self.subscribeButton setUserInteractionEnabled:NO];
        // チェックボックス
    [self.subscribeButtonView.layer setBorderColor:[[UIColor colorWithHexadecimal:0x7f8c8dff] CGColor]];
    [self.subscribeButtonView.layer setBorderWidth:1.0f];
        // 配置
    [self addSubview:self.subscribeButton];
    self.subscribeButton.frame = CGRectMake(
        self.subscribeButtonView.frame.origin.x-10, self.subscribeButtonView.frame.origin.y-10,
        self.subscribeButtonView.frame.size.width+20, self.subscribeButtonView.frame.size.height+20
    );

    // ラベル
    [self.titleLabel setText:discover.title];
    [self.subscribersCountLabel setText:
        [NSString stringWithFormat:@"%d %@", discover.subscribersCount, NSLocalizedString(@"users", @"users")]
    ];
    [self.linkLabel setText:[discover.feedlink absoluteString]];
}


@end

