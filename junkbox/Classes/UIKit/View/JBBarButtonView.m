#import "JBBarButtonView.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"


#pragma mark - JBBarButtonView
@implementation JBBarButtonView


#pragma mark - synthesize
@synthesize labelButton;
@synthesize imageButton;
@synthesize labelAndImageButton;
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
+ (JBBarButtonView *)defaultBarButtonWithDelegate:(id<JBBarButtonViewDelegate>)del
                                            title:(NSString *)title
                                             icon:(NSString *)icon
{
    JBBarButtonView *barButtonView = [UINib UIKitFromClassName:NSStringFromClass([JBBarButtonView class])];
    [barButtonView setDelegate:del];
    [barButtonView setTitle:title
                      image:[IonIcons imageWithIcon:icon
                                               size:20
                                              color:[UIColor colorWithHexadecimal:0x0080ffff]]
                   forState:UIControlStateNormal];
    return barButtonView;
}

- (void)setTitle:(NSString *)title
{
    [self.labelButton setTitle:title forState:UIControlStateNormal];
    [self showLabelButton];
}

- (void)setFont:(UIFont *)font
{
    [self.labelButton.titleLabel setFont:font];
    [self showLabelButton];
}

- (void)setImage:(UIImage *)image
        forState:(UIControlState)state
{
    [self.imageButton setImage:image forState:state];
    [self showImageButton];
}

- (void)setTitle:(NSString *)title
           image:(UIImage *)image
        forState:(UIControlState)state
{
    [self.labelAndImageButton setTitle:title forState:state];
    [self.labelAndImageButton setImage:image forState:state];
    [self showLabelAndImageButton];
}

- (void)setTitle:(NSString *)title
            font:(UIFont *)font
           image:(UIImage *)image
        forState:(UIControlState)state
{
    [self.labelAndImageButton setImage:image forState:state];
    [self.labelAndImageButton.titleLabel setFont:font];
    [self.labelAndImageButton setImage:image forState:state];
    [self showLabelAndImageButton];
}


#pragma mark - private api
/**
 * ラベルボタンを表示
 */
- (void)showLabelButton
{
    [self.labelButton setHidden:NO];
    [self.imageButton setHidden:YES];
    [self.labelAndImageButton setHidden:YES];
}

/**
 * 画像ボタンを表示
 */
- (void)showImageButton
{
    [self.labelButton setHidden:YES];
    [self.imageButton setHidden:NO];
    [self.labelAndImageButton setHidden:YES];
}

/**
 * ラベル&画像ボタンを表示
 */
- (void)showLabelAndImageButton
{
    [self.labelButton setHidden:YES];
    [self.imageButton setHidden:YES];
    [self.labelAndImageButton setHidden:NO];
}


@end
