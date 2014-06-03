#import "JBRSSDiscoverTableViewCell.h"
#import "JBRSSDiscover.h"
#import "JBOutlineLabel.h"
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
@synthesize ratingButton;
@synthesize ratingLabel;
@synthesize subscribeButtonView;
@synthesize subscribeButton;
@synthesize delegate;


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // ボタン
    self.subscribeButton = [NKToggleOverlayButton new];
    [self.subscribeButton setShowOverlay:NO];
    [self.subscribeButton setUserInteractionEnabled:NO];
        // 画像
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:self.subscribeButtonView.frame.size.width
                                                       color:[UIColor colorWithHexadecimal:0x34495eff]]
                            forState:UIControlStateNormal];
    [self.subscribeButton setOnImage:[IonIcons imageWithIcon:icon_ios7_checkmark_empty
                                                        size:self.subscribeButtonView.frame.size.width
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
        // チェックボックス
    [self.subscribeButtonView.layer setBorderColor:[[UIColor colorWithHexadecimal:0x7f8c8dff] CGColor]];
    [self.subscribeButtonView.layer setBorderWidth:1.0f];
        // 配置
    [self addSubview:self.subscribeButton];
    self.subscribeButton.frame = CGRectMake(
        self.subscribeButtonView.frame.origin.x-5, self.subscribeButtonView.frame.origin.y-5,
        self.subscribeButtonView.frame.size.width+10, self.subscribeButtonView.frame.size.height+10
    );
}


#pragma mark - release
- (void)dealloc
{
    [self.subscribeButton removeFromSuperview];
    self.subscribeButtonView = nil;
}


#pragma mark - event listner
- (IBAction)touchedDownWithButton:(UIButton *)button
{
    // レイティング
    if (button == self.ratingButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ratingButtonDidTouchedUpInsideWithCell:)]) {
            [self.delegate ratingButtonDidTouchedUpInsideWithCell:self];
        }
    }
}


#pragma mark - api
- (void)setDiscover:(JBRSSDiscover *)discover
{
    // 設定
    if (discover.isSubscribing != self.subscribeButton.isSelected) {
        [self.subscribeButton setSelected:!(self.subscribeButton.isSelected)
                                 animated:YES];
    }

    // ラベル
    [self.titleLabel setText:discover.title];
    [self.subscribersCountLabel setText:
        [NSString stringWithFormat:@"%@ %@", @(discover.subscribersCount), NSLocalizedString(@"users", @"users")]
    ];
    [self.linkLabel setText:[discover.feedlink absoluteString]];

    // レイティング
    NSMutableString *ratingString = [NSMutableString stringWithCapacity:0];
    const NSInteger max = 5;
    for (NSInteger i = 0; i < max; i++) {
        [ratingString appendString:(i < discover.rate) ? @"★" : @"☆"];
    }
    [self.ratingLabel setText:ratingString];
    [self.ratingLabel setTextColor:[UIColor colorWithHexadecimal:0xf1c40fff]];
    [self.ratingLabel setOutlineColor:[UIColor colorWithHexadecimal:0xbdc3c7ff]];
    [self.ratingLabel setOutlineWidth:0.7f];
    [self.ratingLabel setBackgroundColor:[UIColor clearColor]];
}


@end
