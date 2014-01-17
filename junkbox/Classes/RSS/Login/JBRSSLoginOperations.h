/**************************************************
 *
 * ログイン手順
 *
 * 1 : http://member.livedoor.com/login にPOSTして、クッキー member_sid を取得
 * 2 : https://member.livedoor.com/login/index?livedoor_id=hoge&password=fuga にPOSTして、クッキー .LRC, .LH, .LL (Livedoor Readerのセッション)を取得
 * 3 : http://reader.livedoor.com/ にPOSTして、クッキー reader_sid (Livedoor ReaderのApiKey)を取得
 *
 **************************************************/


#pragma mark - JBRSSLoginOperations
/// RSS Reader ログイン
@interface JBRSSLoginOperations : NSObject {
}


#pragma mark - property
/// ユーザー名
@property (nonatomic, strong) NSString *username;
/// パスワード
@property (nonatomic, strong) NSString *password;
/// ログイン処理完了イベント
@property (nonatomic, copy) void (^handler)(NSHTTPURLResponse *response, id object, NSError *error);
/// ログインに必要な処理一覧
@property (nonatomic, strong) NSArray *operations;


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


#pragma mark - api
/**
 * 処理開始
 */
- (void)start;


@end
