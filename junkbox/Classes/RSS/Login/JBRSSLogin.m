#import "JBRSSLogin.h"
#import "JBRSSConstant.h"


#pragma mark - JBRSSLogin
@implementation JBRSSLogin


#pragma mark - synthesize
@synthesize authorizeIsActive;


#pragma mark - class method
+ (JBRSSLogin *)sharedInstance
{
    static dispatch_once_t onceToken = NULL;
    static JBRSSLogin *_JBRSSLogin = nil;
    dispatch_once(&onceToken, ^ () {
        _JBRSSLogin = [JBRSSLogin new];
    });
    return _JBRSSLogin;
}


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.authorizeIsActive = NO;
    }
    return self;
}


#pragma mark - api
- (BOOL)authorized
{
    NSString *ldrApiKey = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsLivedoorReaderApiKey];
    BOOL ldrIsAuthorized = !(ldrApiKey == nil || [ldrApiKey isKindOfClass:[NSNull class]] || [ldrApiKey isEqualToString:@""]);
    return ldrIsAuthorized;
}


@end
