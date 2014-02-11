#import "JBBookmarkCatalogOperation.h"
#import "NSURLRequest+JBBookmark.h"


#pragma mark - JBBookmarkCatalogOperation
@implementation JBBookmarkCatalogOperation


#pragma mark - synthesize


#pragma mark - initializer
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
{
    self = [super initWithRequest:[NSMutableURLRequest JBBookmarkCatalogRequest]
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
