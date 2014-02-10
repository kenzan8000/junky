#import "JBBarButtonView.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIColor+Hexadecimal.h"
// Pods
#import "IonIcons.h"
#import "SAMBadgeView.h"
#import "JBQBFlatButton.h"


#pragma mark - JBBarButtonView
@implementation JBBarButtonView


#pragma mark - synthesize
@synthesize labelButton;
@synthesize imageButton;
@synthesize labelAndImageButton;
@synthesize badgeView;
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
    return [JBBarButtonView defaultBarButtonWithDelegate:del
                                                   title:title
                                                    icon:icon
                                                   color:[UIColor colorWithHexadecimal:0x0080ffff]];
}

+ (JBBarButtonView *)defaultBarButtonWithDelegate:(id<JBBarButtonViewDelegate>)del
                                            title:(NSString *)title
                                             icon:(NSString *)icon
                                            color:(UIColor *)color
{
    JBBarButtonView *barButtonView = [UINib UIKitFromClassName:NSStringFromClass([JBBarButtonView class])];
    [barButtonView setDelegate:del];
    if (title && icon) {
        [barButtonView setTitle:title
                          image:[IonIcons imageWithIcon:icon
                                                   size:18
                                                  color:color]
                       forState:UIControlStateNormal];
    }
    else if (title) {
        [barButtonView setTitle:title];
    }
    else if (icon) {
        [barButtonView setImage:[IonIcons imageWithIcon:icon
                                                   size:18
                                                  color:color]
                       forState:UIControlStateNormal];
    }
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

- (void)setBadgeText:(NSString *)text
               color:(UIColor *)color
{
    if (text && color && [text isKindOfClass:[NSString class]] && [color isKindOfClass:[UIColor class]]) {
        self.badgeView.textLabel.text = text;
        self.badgeView.badgeColor = color;
        [self.badgeView setHidden:NO];
    }
    else {
        [self.badgeView setHidden:YES];
    }
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
    [self designButtons];
}

/**
 * 画像ボタンを表示
 */
- (void)showImageButton
{
    [self.labelButton setHidden:YES];
    [self.imageButton setHidden:NO];
    [self.labelAndImageButton setHidden:YES];
    [self designButtons];
}

/**
 * ラベル&画像ボタンを表示
 */
- (void)showLabelAndImageButton
{
    [self.labelButton setHidden:YES];
    [self.imageButton setHidden:YES];
    [self.labelAndImageButton setHidden:NO];
    [self designButtons];
}

/**
 * ボタンのデザイン
 */
- (void)designButtons
{
    NSArray *buttons = @[self.labelButton, self.imageButton, self.labelAndImageButton];
    for (JBQBFlatButton *button in buttons) {
        [button setFaceColor:[UIColor colorWithHexadecimal:0xecf0f1ff] forState:UIControlStateNormal];
        [button setSideColor:[UIColor colorWithHexadecimal:0xbdc3c7ff] forState:UIControlStateNormal];
        [button setFaceColor:[UIColor colorWithHexadecimal:0x95a5a6ff] forState:UIControlStateHighlighted];
        [button setSideColor:[UIColor colorWithHexadecimal:0x7f8c8dff] forState:UIControlStateHighlighted];
        button.depth = 0;
        button.margin = 0;
        button.radius = 2;
    }
}


@end
