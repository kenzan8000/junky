#import "JBRSSFeedUnreadOperation.h"
#import "NSURLRequest+JBRSS.h"


#pragma mark - JBRSSFeedUnreadOperation
@implementation JBRSSFeedUnreadOperation


#pragma mark - synthesize
@synthesize subscribeId;


#pragma mark - initializer
- (id)initWithSubscribeId:(NSString *)sId
                  handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    self = [super initWithRequest:[NSMutableURLRequest JBRSSUnreadRequestWithSubscribeId:sId]
                          handler:h];
    if (self) {
        self.subscribeId = sId;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.subscribeId = nil;
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

- (NSURL *)APIURL
{
    return [self.request URL];
}


#pragma mark - private api


@end

