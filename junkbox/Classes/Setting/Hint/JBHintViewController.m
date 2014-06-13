#import "JBHintViewController.h"
#import "JBNavigationBarTitleView.h"
// Pods
#import "IonIcons.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
// Pods-Extension
#import "JBQBFlatButton.h"
// UIKit-Extension
#import "UIColor+Hexadecimal.h"
#import "UINib+UIKit.h"
#import "UIBarButtonItem+Space.h"


#pragma mark - JBHintViewController
@implementation JBHintViewController


#pragma mark - synthesize
@synthesize backButtonView;
@synthesize hint;
@synthesize playButton;
@synthesize hintImageView;


#pragma mark - initializer
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.backButtonView = nil;
    self.hint = nil;
    [self.hintImageView removeFromSuperview];
    self.hintImageView = nil;
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(self.hint, @"ヒント"), NSLocalizedString(@"Hint", @"ヒント")]];
    self.navigationItem.titleView = titleView;
        // 戻る
    self.backButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:nil
                                                                   icon:icon_arrow_left_c];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];
        //
    JBBarButtonView *emptyButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                               title:NSLocalizedString(@"Menu", @"メニューボタン")
                                                                                icon:icon_navicon];
    [emptyButtonView setHidden:YES];
    [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:emptyButtonView]]
                                       animated:NO];
    // 再生ボタン
    [self.playButton setFaceColor:[UIColor colorWithHexadecimal:0xffa800ff] forState:UIControlStateNormal];
    [self.playButton setFaceColor:[UIColor colorWithHexadecimal:0xe08200ff] forState:UIControlStateHighlighted];
    [self.playButton setSideColor:[UIColor colorWithHexadecimal:0xe08200ff] forState:UIControlStateNormal];
    [self.playButton setSideColor:[UIColor colorWithHexadecimal:0xc16000ff] forState:UIControlStateHighlighted];
    [self.playButton setImage:[IonIcons imageWithIcon:icon_ios7_play size:self.playButton.frame.size.width color:[UIColor colorWithHexadecimal:0xffffffff]]
                     forState:UIControlStateNormal];
    [self.playButton setImage:[IonIcons imageWithIcon:icon_ios7_play size:self.playButton.frame.size.width color:[UIColor colorWithHexadecimal:0xffffffff]]
                     forState:UIControlStateHighlighted];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - JBBarButtonViewDelegate
/**
 * ボタン押下
 * @param barButtonView barButtonView
 */
- (void)touchedUpInsideButtonWithBarButtonView:(JBBarButtonView *)barButtonView
{
    if (barButtonView == self.backButtonView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.hintImageView = [[YLImageView alloc] initWithFrame:window.frame];
    self.hintImageView.image = [YLGIFImage imageNamed:[NSString stringWithFormat:@"%@.gif", self.hint]];
    [window addSubview:self.hintImageView];

    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.backButtonView.userInteractionEnabled = NO;
    self.playButton.userInteractionEnabled = NO;

    // アニメーション
    self.hintImageView.alpha = 0;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.30f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        weakSelf.hintImageView.alpha = 1;
    }
                     completion:^ (BOOL finished) {
        UIWindow *w = (UIWindow *)[weakSelf.hintImageView superview];
        if ([w isKindOfClass:[UIWindow class]]) { w.windowLevel = UIWindowLevelAlert; }
    }];
}


#pragma mark - private api
- (void)touchesBegan:(NSSet*)touches
           withEvent:(UIEvent*)event
{
    if (self.hintImageView == nil) { return; }

    UIWindow *window = (UIWindow *)[self.hintImageView superview];
    if ([window isKindOfClass:[UIWindow class]]) { window.windowLevel = UIWindowLevelNormal; }

    // アニメーション
    self.hintImageView.alpha = 1;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.30f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ () {
        weakSelf.hintImageView.alpha = 0;
    }
                     completion:^ (BOOL finished) {
        [weakSelf.hintImageView removeFromSuperview];
        weakSelf.hintImageView = nil;
        weakSelf.tabBarController.tabBar.userInteractionEnabled = YES;
        weakSelf.backButtonView.userInteractionEnabled = YES;
        weakSelf.playButton.userInteractionEnabled = YES;
    }];
}

@end
