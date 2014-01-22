/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBRSSPinAllOperation
/// Livedoor Reader PIN一覧取得
@interface JBRSSPinAllOperation : ISHTTPOperation {
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
