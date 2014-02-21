#import "JBSettingSocialTableViewCell.h"
#import <Social/Social.h>
// Pods
#import "MTStatusBarOverlay.h"
// UIkit-Extension
#import "UIColor+Hexadecimal.h"
/// Pods-Extension
#import "JBQBFlatButton.h"
#import "SSGentleAlertView+Junkbox.h"


#pragma mark - JBSettingSocialTableViewCell
@implementation JBSettingSocialTableViewCell


#pragma mark - synthesize
@synthesize reviewButton;
@synthesize delegate;


#pragma mark - class method
+ (CGFloat)cellHeight
{
    return kJBSettingSocialTableViewCellHeight;
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
        NSURL *URL = [NSURL URLWithString:kURLAppStore];
        switch (index) {
            // レビューしない
            case 0:
                break;
            // レビューする
            case 1:
                if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                    [[UIApplication sharedApplication] openURL:URL];
                }
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
        [self tweet];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Publish", @"共有する")]) {
        [self publishToFacebook];
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


#pragma mark - private api
/**
 * tweet
 */
- (void)tweet
{
    [self postToSocialWithServiceType:SLServiceTypeTwitter];
}

/**
 * publish to facebook
 */
- (void)publishToFacebook
{
    [self postToSocialWithServiceType:SLServiceTypeFacebook];
}

/**
 * Socialへ投稿
 * @param serviceType Socialの種類
 */
- (void)postToSocialWithServiceType:(NSString *)serviceType
{
    // 投稿
     if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [vc setInitialText:[NSString stringWithFormat:@"%@ %@",
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
            kURLAppStore
        ]];
        [vc setCompletionHandler:^ (SLComposeViewControllerResult result) {
            // 成功
            if (result == SLComposeViewControllerResultDone) {
                // ステータスバーに表示
                dispatch_async(dispatch_get_main_queue(), ^ () {
                    NSString *message = nil;
                    if ([serviceType isEqualToString:SLServiceTypeTwitter]) {
                        message = NSLocalizedString(@"Tweet succeeded", @"Tweet成功");
                    }
                    else if ([serviceType isEqualToString:SLServiceTypeFacebook]) {
                        message = NSLocalizedString(@"Publish on Facebook succeeded", @"Facebook投稿成功");
                    }
                    [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:message
                                                                           duration:2.5f
                                                                           animated:YES];
                });
            }
            else if (result == SLComposeViewControllerResultCancelled) {
            }
        }];

        // Delegate
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(presentViewController:cell:)]) {
            [self.delegate presentViewController:vc
                                       cell:self];
        }
    }
    // アカウント未設定
    else {
        NSString *message = nil;
        if ([serviceType isEqualToString:SLServiceTypeTwitter]) {
            message = NSLocalizedString(@"No Twitter account. You can add or create a Twitter account in Settings.", @"Twitterアカウント未設定");
        }
        else if ([serviceType isEqualToString:SLServiceTypeFacebook]) {
            message = NSLocalizedString(@"No Facebook account. You can add or create a Facebook account in Settings.", @"Facebookアカウント未設定");
        }
        [SSGentleAlertView showWithMessage:message
                              buttonTitles:@[NSLocalizedString(@"Confirm", @"確認"),]
                                  delegate:nil];
     }
}


@end
/*
                NSString *message = nil;
                if ([serviceType isEqualToString:SLServiceTypeTwitter]) {
                    message = NSLocalizedString(@"Tweet failed", @"Tweet失敗");
                }
                else if ([serviceType isEqualToString:SLServiceTypeFacebook]) {
                    message = NSLocalizedString(@"Publish on Facebook failed", @"Facebook投稿失敗");
                }
*/
