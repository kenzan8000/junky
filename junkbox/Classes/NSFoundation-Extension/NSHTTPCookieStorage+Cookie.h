#pragma mark - NSHTTPCookieStorage+Cookie
/// Cookie処理
@interface NSHTTPCookieStorage (Cookie)


#pragma mark - api
/**
 * Cookieを持っているかどうか
 * @param name Cookieの名前
 * @param domain Cookieのドメイン
 * @return BOOL
 */
- (BOOL)hasCookieWithName:(NSString *)name
                   domain:(NSString *)domain;

/**
 * Cookieを削除
 * @param name Cookieの名前
 * @param domain Cookieのドメイン
 */
- (void)deleteCookieWithName:(NSString *)name
                      domain:(NSString *)domain;

/**
 * Cookieの値
 * @param name Cookieの名前
 * @param domain Cookieのドメイン
 * @return Cookieの値、ない場合nil
 */
- (NSString *)valueWithName:(NSString *)name
                     domain:(NSString *)domain;


@end
