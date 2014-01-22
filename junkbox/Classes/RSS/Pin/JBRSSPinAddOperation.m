#import "JBRSSPinAddOperation.h"
// NSFoundation-Extension
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSPinAddOperation
@implementation JBRSSPinAddOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
             pinTitle:(NSString *)pinTitle
              pinLink:(NSString *)pinLink
{
    self = [super initWithRequest:[NSMutableURLRequest JBRSSAddPinRequestWithTitle:pinTitle
                                                                              link:pinLink]
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
