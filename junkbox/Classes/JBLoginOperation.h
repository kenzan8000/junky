/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBLoginOperation
/// ログイン
@interface JBLoginOperation : ISHTTPOperation {
}


#pragma mark - property
/// ユーザー名
@property (strong) NSString *username;
/// パスワード
@property (strong) NSString *password;


#pragma mark - initializer
/**
 * construct
 * @param username username
 * @param password password
 * @param handler handler
 * @param request request
 * @return id
 */
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler
               request:(NSURLRequest *)request;


@end
