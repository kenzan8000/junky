#import "JBRSSFeedDiscoverOperation.h"
// NSFoundation-Extension
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedDiscoverOperation
@implementation JBRSSFeedDiscoverOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
                  URL:(NSURL *)URL
{
    // 通信後の処理
    self = [super initWithRequest:[NSMutableURLRequest JBRSSFeedDiscoverRequestWithURL:URL]
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
