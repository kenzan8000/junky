#import "JBRSSFeedSubscribeOperation.h"
// NSFoundation-Extension
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedSubscribeOperation
@implementation JBRSSFeedSubscribeOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
                  URL:(NSURL *)URL
{
    // 通信後の処理
    self = [super initWithRequest:[NSMutableURLRequest JBRSSFeedSubscribeRequestWithURL:URL]
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
