#import "JBSettingReviewTableViewCell.h"
// UIkit-Extension
#import "UIColor+Hexadecimal.h"
/// Pods-Extension
#import "JBQBFlatButton.h"
#import "SSGentleAlertView+Junkbox.h"


#pragma mark - JBSettingReviewTableViewCell
@implementation JBSettingReviewTableViewCell


#pragma mark - synthesize
@synthesize reviewButton;


#pragma mark - class method
+ (CGFloat)cellHeight
{
    return kJBSettingReviewTableViewCellHeight;
}


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
    self.reviewButton.depth = 2.0f;
    self.reviewButton.margin = 2.0f;
}


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - SSGentleAlertViewDelegate
- (void)alertView:(SSGentleAlertView *)alertView
clickedButtonAtIndex:(NSInteger)index
{
    NSString *title = [self.reviewButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:NSLocalizedString(@"Review", @"レビュー導線")]) {
        switch (index) {
            // レビューしない
            case 0:
                break;
            // レビューする
            case 1:
                /*
                if ([[UIApplication sharedApplication] canOpenURL:]) {
                    [[UIApplication sharedApplication] openURL:];
                }
                */
                break;
        }
    }
    else if ([title isEqualToString:NSLocalizedString(@"Tweet", @"ツイートする")]) {
    }
    else if ([title isEqualToString:NSLocalizedString(@"Publish", @"共有する")]) {
    }
    else if ([title isEqualToString:NSLocalizedString(@"Pull Request", @"プルリクエストする")]) {
    }

}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    NSString *title = [self.reviewButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:NSLocalizedString(@"Review", @"レビュー導線")]) {
        [SSGentleAlertView showWithMessage:NSLocalizedString(@"If you like 'Junky', please rate it. Thanks!", @"Junkyが気に入ったらぜひレビューして下さい♪")
                              buttonTitles:@[NSLocalizedString(@"No, Thanks", @"レビューしない"), NSLocalizedString(@"Rate Now", @"レビューする")]
                                  delegate:self];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Tweet", @"ツイートする")]) {
    }
    else if ([title isEqualToString:NSLocalizedString(@"Publish", @"共有する")]) {
    }
    else if ([title isEqualToString:NSLocalizedString(@"Pull Request", @"プルリクエストする")]) {
    }
}


#pragma mark - api
- (void)setTitleWithTitleString:(NSString *)title
{
    [self.reviewButton setTitle:title
                       forState:UIControlStateNormal];

    // ボタン色
    NSArray *colors = nil;
    if ([title isEqualToString:NSLocalizedString(@"Review", @"レビュー導線")]) {
        colors = @[
            [UIColor colorWithHexadecimal:0xb0b0b0ff],
            [UIColor colorWithHexadecimal:0x909090ff],
            [UIColor colorWithHexadecimal:0x909090ff],
            [UIColor colorWithHexadecimal:0x707070ff],
        ];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Tweet", @"ツイートする")]) {
        colors = @[
            [UIColor colorWithHexadecimal:0x00c6f2ff],
            [UIColor colorWithHexadecimal:0x00b0cfff],
            [UIColor colorWithHexadecimal:0x00b0cfff],
            [UIColor colorWithHexadecimal:0x0098b8ff],
        ];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Publish", @"共有する")]) {
        colors = @[
            [UIColor colorWithHexadecimal:0x3b5998ff],
            [UIColor colorWithHexadecimal:0x284181ff],
            [UIColor colorWithHexadecimal:0x284181ff],
            [UIColor colorWithHexadecimal:0x102868ff],
        ];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Pull Request", @"プルリクエストする")]) {
        colors = @[
            [UIColor colorWithHexadecimal:0x666666ff],
            [UIColor colorWithHexadecimal:0x444444ff],
            [UIColor colorWithHexadecimal:0x444444ff],
            [UIColor colorWithHexadecimal:0x222222ff],
        ];
    }
    [self.reviewButton setFaceColor:colors[0]
                           forState:UIControlStateNormal];
    [self.reviewButton setFaceColor:colors[1]
                           forState:UIControlStateHighlighted];
    [self.reviewButton setSideColor:colors[2]
                           forState:UIControlStateNormal];
    [self.reviewButton setSideColor:colors[3]
                           forState:UIControlStateHighlighted];
}

- (void)setIconWithImage:(UIImage *)image
{
    [self.reviewButton setImage:image
                       forState:UIControlStateNormal];
}

@end
