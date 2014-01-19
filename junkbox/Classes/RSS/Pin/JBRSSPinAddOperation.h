/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBRSSPinAddOperation
/// Livedoor Reader PIN追加
@interface JBRSSPinAddOperation : ISHTTPOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @param pinTitle pinTitleの名前でpinに追加される
 * @param pinLink pinに追加されるURL
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h
             pinTitle:(NSString *)pinTitle
              pinLink:(NSString *)pinLink;


@end
