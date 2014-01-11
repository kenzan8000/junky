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
- (BOOL)hasCookieWithNames:(NSArray *)names
                   domains:(NSArray *)domains;

/**
 * Cookieを削除
 * @param name Cookieの名前
 * @param domain Cookieのドメイン
 */
- (void)deleteCookieWithNames:(NSArray *)names
                      domains:(NSArray *)domains;

/**
 * Cookieの値
 * @param name Cookieの名前
 * @param domain Cookieのドメイン
 * @return Cookieの値、ない場合nil
 */
- (NSString *)valueWithName:(NSString *)name
                     domain:(NSString *)domain;

/**
 * NSURLResponseからCookieを追加
 * @param URLResponse NSURLResponse
 */
- (void)addCookiesWithURLResponse:(NSURLResponse *)URLResponse;


@end
