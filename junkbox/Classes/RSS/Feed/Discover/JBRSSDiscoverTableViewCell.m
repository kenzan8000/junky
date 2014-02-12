#import "JBRSSDiscoverTableViewCell.h"
#import "JBRSSDiscover.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
// Pods-Extension
#import "JBQBFlatButton.h"


#pragma mark - JBRSSDiscoverTableViewCell
@implementation JBRSSDiscoverTableViewCell


#pragma mark - synthesize
@synthesize titleLabel;
@synthesize subscribersCountLabel;
@synthesize linkLabel;
@synthesize subscribeButton;
@synthesize unsubscribeButton;


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
}


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    if (button == self.subscribeButton) {
    }
    else if (button == self.unsubscribeButton) {
    }
}


#pragma mark - api
- (void)setDiscover:(JBRSSDiscover *)discover
{
    // ボタン
    [self.subscribeButton setTitle:NSLocalizedString(@"Subscribe", @"購読する")
                          forState:UIControlStateNormal];
    [self.subscribeButton setFaceColor:[UIColor colorWithHexadecimal:0xff7058ff] forState:UIControlStateNormal];
    [self.subscribeButton setFaceColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateHighlighted];
    [self.subscribeButton setSideColor:[UIColor colorWithHexadecimal:0xe74c3cff] forState:UIControlStateNormal];
    [self.subscribeButton setSideColor:[UIColor colorWithHexadecimal:0xc0392bff] forState:UIControlStateHighlighted];

    [self.unsubscribeButton setTitle:NSLocalizedString(@"Unsubscribe", @"購読をやめる")
                            forState:UIControlStateNormal];
    [self.unsubscribeButton setFaceColor:[UIColor colorWithHexadecimal:0x95a5a6ff] forState:UIControlStateNormal];
    [self.unsubscribeButton setFaceColor:[UIColor colorWithHexadecimal:0x7f8c8dff] forState:UIControlStateHighlighted];
    [self.unsubscribeButton setSideColor:[UIColor colorWithHexadecimal:0x7f8c8dff] forState:UIControlStateNormal];
    [self.unsubscribeButton setSideColor:[UIColor colorWithHexadecimal:0x5f6c6dff] forState:UIControlStateHighlighted];

    // ラベル
    [self.titleLabel setText:discover.title];
    [self.subscribersCountLabel setText:
        [NSString stringWithFormat:@"%d%@", discover.subscribersCount, NSLocalizedString(@"users", @"users")]
    ];
    [self.linkLabel setText:[discover.feedlink absoluteString]];
}


@end
