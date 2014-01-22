#import "JBRSSFeedSubsUnreadOperation.h"
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedSubsUnreadOperation
@implementation JBRSSFeedSubsUnreadOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    self = [super initWithRequest:[NSMutableURLRequest JBRSSSubsUnreadRequest]
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
