#pragma mark - NSURLRequest+JBRSS
/// NSMutableURLRequest Junkbox拡張(Livedoor Reader API)
@interface NSMutableURLRequest (JBRSS)


#pragma mark - api
/**
 * ログイン
 * @param livedoorId livedoorId
 * @param password passowrd
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSLoginRequestWithLivedoorId:(NSString *)livedoorId
                                                password:(NSString *)password;

/**
 * 未読フィード一覧を取得
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest;


@end
