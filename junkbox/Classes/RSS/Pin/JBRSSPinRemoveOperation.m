#import "JBRSSConstant.h"
#import "JBRSSPinRemoveOperation.h"
#import "JBRSSOperationQueue.h"
// NSFoundation-Extension
#import "NSURLRequest+JBRSS.h"
// Connection
#import "StatusCode.h"
// Pods
#import "Reachability.h"


#pragma mark - JBRSSPinRemoveOperation
@implementation JBRSSPinRemoveOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
              pinLink:(NSString *)pinLink
{
    self = [super initWithRequest:[NSMutableURLRequest JBRSSRemovePinRequestWithLink:pinLink]
                          handler:h];
    if (self) {
    }
    return self;
}


#pragma mark - api
- (void)start
{
    // ネットワークに接続できない
    if ([self isReachable] == NO) {
        [self cancelBeforeConnectionIfNotReachable];
        return;
    }

    [super start];
}


#pragma mark - private api


@end
