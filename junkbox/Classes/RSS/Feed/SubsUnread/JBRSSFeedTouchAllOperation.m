#import "JBRSSFeedTouchAllOperation.h"
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedTouchAllOperation
@implementation JBRSSFeedTouchAllOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
          subscribeId:(NSString *)subscribeId
{
    self = [super initWithRequest:[NSMutableURLRequest JBRSSTouchAllRequestWithSubscribeId:subscribeId]
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
