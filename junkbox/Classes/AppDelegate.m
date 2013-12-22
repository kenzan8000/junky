#import "AppDelegate.h"
/// UIkit-Extension
#import "UIStoryboard+UIKit.h"
/// Pods
#import "NLCoreData.h"


#pragma mark - AppDelegate
@implementation AppDelegate


#pragma mark - life cycle
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // CoreData
    if ([[NLCoreData shared] storeExists] == NO) {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"JBRSSFeedSubsUnread"
                                             withExtension:@"momd"];
        [[NLCoreData shared] useDatabaseFile:[URL absoluteString]];
    }

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
