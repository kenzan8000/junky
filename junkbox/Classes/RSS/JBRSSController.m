#import "JBRSSController.h"
/// UIKit-Extension
#import "UIStoryboard+UIKit.h"


#pragma mark - JBRSSController
@implementation JBRSSController


#pragma mark - synthesize


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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    [self setViewControllers:@[[UIStoryboard UIKitFromName:kStoryboardRSSFeed]]];

    // login
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidSuccess:)
                                                 name:kNotificationRSSLoginSuccess
                                               object:nil];
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


#pragma mark - notification
/**
 * ログイン成功
 * @param notification notification
 **/
- (void)loginDidSuccess:(NSNotification *)notification
{
}


@end
