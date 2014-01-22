#import "JBRSSOperation.h"


#pragma mark - JBRSSPinRemoveOperation
/// Livedoor Reader PIN削除
@interface JBRSSPinRemoveOperation : JBRSSOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param pinLink pinに追加されるURL
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
              pinLink:(NSString *)pinLink;


@end
