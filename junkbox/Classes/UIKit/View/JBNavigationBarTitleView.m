#import "JBNavigationBarTitleView.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"


#pragma mark - JBNavigationBarTitleView
@implementation JBNavigationBarTitleView


#pragma mark - synthesize
@synthesize titleLabel;
@synthesize titleButton;
@synthesize delegate;


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
    self.delegate = nil;
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithTitleButton:(UIButton *)button
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(touchedUpInsideTitleButtonWithNavigationBarTitleViewDelegate:)]) {
            [weakSelf.delegate touchedUpInsideTitleButtonWithNavigationBarTitleViewDelegate:weakSelf];
        }
    });
}


#pragma mark - api
- (NSString *)title
{
    NSString *titleString = nil;
    if (self.titleLabel.hidden == NO) {
        titleString = self.titleLabel.text;
    }
    else if (self.titleButton.hidden == NO) {
        titleString = [self.titleButton titleForState:UIControlStateNormal];
    }
    return titleString;
}

- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleButton setTitle:title
                      forState:UIControlStateNormal];
    [self.titleButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
    [self.titleButton setTitleColor:[UIColor colorWithHexadecimal:0xbdc3c7ff]
                           forState:UIControlStateHighlighted];
}

- (void)useLabel
{
    [self.titleLabel setHidden:NO];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setMinimumScaleFactor:0.6f];
    [self.titleButton setHidden:YES];
}

- (void)useButton
{
    [self.titleLabel setHidden:YES];
    [self.titleButton setHidden:NO];
    self.titleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleButton.titleLabel setMinimumScaleFactor:0.6f];
}


@end
