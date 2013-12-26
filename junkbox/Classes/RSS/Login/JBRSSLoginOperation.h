#import "JBLoginOperation.h"


#pragma mark - JBRSSLoginOperation
/// RSS Reader ログイン
@interface JBRSSLoginOperation : JBLoginOperation {
}


#pragma mark - initializer
/**
 * construct
 * @param username username
 * @param password password
 * @param handler handler
 * @return id
 */
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;

/**
 * 401の時用 再認証
 * @param handler handler
 * @return id
 */
- (id)initReauthenticationWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;


@end
