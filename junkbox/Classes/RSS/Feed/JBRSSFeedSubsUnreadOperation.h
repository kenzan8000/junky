/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBRSSFeedSubsUnreadOperation
/// 未読フィード一覧
@interface JBRSSFeedSubsUnreadOperation : ISHTTPOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;


@end
