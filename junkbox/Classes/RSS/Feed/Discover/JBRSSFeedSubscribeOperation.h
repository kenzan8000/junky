#import "JBRSSOperation.h"


#pragma mark - JBRSSFeedSubscribeOperation
/// RSSフィードを登録
@interface JBRSSFeedSubscribeOperation : JBRSSOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param URL feedlink
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
                  URL:(NSURL *)URL;


@end
