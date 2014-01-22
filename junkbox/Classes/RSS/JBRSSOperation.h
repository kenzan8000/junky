/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBRSSOperation
/// RSS API のISHTTPOperation
@interface JBRSSOperation : ISHTTPOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @return id
 */
- (id)initWithRequest:(NSURLRequest *)request
              handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;


#pragma mark - api
/**
 * 通信できるかどうか
 * @return BOOL
 */
- (BOOL)isReachable;

/**
 * 通信できなかった場合の処理
 */
- (void)cancelBeforeConnectionIfNotReachable;


@end
