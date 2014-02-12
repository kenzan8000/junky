#import "JBRSSOperation.h"


#pragma mark - JBRSSFeedDiscoverOperation
/// URLからRSSフィードを探す
@interface JBRSSFeedDiscoverOperation : JBRSSOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param URL URL
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
                  URL:(NSURL *)URL;


@end
