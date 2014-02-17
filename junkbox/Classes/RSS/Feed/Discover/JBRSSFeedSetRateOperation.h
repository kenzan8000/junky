#import "JBRSSOperation.h"


#pragma mark - JBRSSFeedSetRateOperation
/// RSSフィードレイティングを変更
@interface JBRSSFeedSetRateOperation : JBRSSOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param subscribeId subscribeId
 * @param rate rate
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
          subscribeId:(NSString *)subscribeId
                 rate:(NSNumber *)rate;


@end
