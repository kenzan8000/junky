#import "JBLicenceViewController.h"
#import "JBNavigationBarTitleView.h"
// Pods
#import "IonIcons.h"
// UIKit-Extension
#import "UINib+UIKit.h"
#import "UIBarButtonItem+Space.h"


#pragma mark - JBLicenceViewController
@implementation JBLicenceViewController


#pragma mark - synthesize
@synthesize backButtonView;
@synthesize licenceTextView;


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
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    // ナビゲーションバー
        // タイトル
    JBNavigationBarTitleView *titleView = [UINib UIKitFromClassName:NSStringFromClass([JBNavigationBarTitleView class])];
    [titleView setTitle:NSLocalizedString(@"Licence", @"ライセンス情報")];
    self.navigationItem.titleView = titleView;
        // 戻る
    self.backButtonView = [JBBarButtonView defaultBarButtonWithDelegate:self
                                                                  title:nil
                                                                   icon:icon_arrow_left_a];
    [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem spaceBarButtonItemWithWidth:-16], [[UIBarButtonItem alloc] initWithCustomView:self.backButtonView]]
                                      animated:NO];

    // Licence
    [self initializeLicence];
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


#pragma mark - private api
/**
 * licenceのテキストを設定
 */
- (void)initializeLicence
{
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:
        [[NSBundle mainBundle] pathForResource:kPlistAcknowledgements ofType:@"plist"]
    ];
    if ([plist isKindOfClass:[NSDictionary class]] == NO) { return; }
    if ([[plist allKeys] containsObject:@"PreferenceSpecifiers"] == NO) { return; }
    NSArray *licences = plist[@"PreferenceSpecifiers"];
    if ([licences isKindOfClass:[NSArray class]] == NO) { return; }

    NSMutableString *text = [NSMutableString stringWithCapacity:0];
    [text appendString:@"\n"];
    [text appendString:@"\n"];
    for  (NSDictionary *licence in licences) {
        if ([licence isKindOfClass:[NSDictionary class]] == NO) { continue; }
        NSArray *allKeys = [licence allKeys];
        if ([allKeys containsObject:@"Title"] == NO) { continue; }
        if ([allKeys containsObject:@"FooterText"] == NO) { continue; }
        [text appendString:licence[@"Title"]];
        [text appendString:@"\n"];
        [text appendString:@"\n"];
        [text appendString:licence[@"FooterText"]];
        [text appendString:@"\n"];
        [text appendString:@"\n"];
        [text appendString:@"\n"];
        [text appendString:@"\n"];
    }
    [self.licenceTextView setText:text];
    self.licenceTextView.editable = NO;
}


@end
