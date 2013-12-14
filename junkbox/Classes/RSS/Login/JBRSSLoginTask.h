#pragma mark - JBRSSLoginTask
/// ログイン画面
@interface JBRSSLoginTask : NSObject {
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
 * @return id
 */
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password;


#pragma mark - api (Livedoor Reader)
/**
 * livedoor reader にログイン
 * @param handler ログイン処理完了(error: nil->成功, the others->失敗)
 */
- (void)livedoorReaderLoginWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;



@end
