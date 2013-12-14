/// Pods
#import "ISHTTPOperation.h"


#pragma mark - JBRSSLoginOperation
/// ログイン
@interface JBRSSLoginOperation : ISHTTPOperation {
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
 * @return id
 */
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password
               handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;


@end
