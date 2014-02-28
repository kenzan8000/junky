#pragma mark - JBRSSLogin
/// RSS Reader ログイン関係
@interface JBRSSLogin : NSObject {
}


#pragma mark - property
/// ログイン処理中かどうか
@property (nonatomic, assign) BOOL authorizeIsActive;


#pragma mark - class method
+ (JBRSSLogin *)sharedInstance;


#pragma mark - api
/**
 * 認証が通っているかどうか
 * @return BOOL
 */
- (BOOL)authorized;


@end
