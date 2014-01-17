#import "JBBarButtonView.h"


#pragma mark - JBBarButtonView
@implementation JBBarButtonView


#pragma mark - synthesize
@synthesize button;
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
    self.button = nil;
    self.delegate = nil;
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(touchedUpInsideButtonWithBarButtonView:)]) {
            [weakSelf.delegate touchedUpInsideButtonWithBarButtonView:weakSelf];
        }
    });
}


#pragma mark - api
- (void)setTitle:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
}


@end
