#import "AppDelegate.h"
#import "JBRSSConstant.h"
#import "JBBookmarkConstant-Private.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSPinList.h"
/// UIkit-Extension
#import "UIStoryboard+UIKit.h"
/// Pods
#import "NLCoreData.h"


void uncaughtExceptionHandler(NSException *exception)
{
    JBLog(@"Exception: %@", exception);
    JBLog(@"Stack Trace: %@", [exception callStackSymbols]);
}


#pragma mark - AppDelegate
@implementation AppDelegate


#pragma mark - life cycle
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    // CoreData
    if ([[NLCoreData shared] storeExists] == NO) {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:kXCDataModelName
                                             withExtension:@"momd"];
        [[NLCoreData shared] useDatabaseFile:[URL absoluteString]];
    }
        // RSSのあとで読む一覧
    [[JBRSSPinList sharedInstance] loadAllPinFromLocal];

    // Connection
    [[JBRSSOperationQueue defaultQueue] setMaxConcurrentOperationCount:kMaxOperationCountOfRSSConnection];

    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[UIStoryboard UIKitFromName:kStoryboardMainStoryboard]];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


@end
