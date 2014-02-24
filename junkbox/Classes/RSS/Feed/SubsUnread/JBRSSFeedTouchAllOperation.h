#import "JBRSSOperation.h"


#pragma mark - JBRSSFeedTouchAllOperation
/// フィードを既読化
@interface JBRSSFeedTouchAllOperation : JBRSSOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param subscribeId フィードのsubscribeId
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
          subscribeId:(NSString *)subscribeId;


@end
