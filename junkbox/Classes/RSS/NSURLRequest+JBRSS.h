#pragma mark - NSURLRequest+JBRSS
/// NSMutableURLRequest Junkbox拡張(Livedoor Reader API)
@interface NSMutableURLRequest (JBRSS)


#pragma mark - api
/**
 * ログイン
 * @param livedoorID livedoorID
 * @param password passowrd
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSLoginRequestWithLivedoorID:(NSString *)livedoorID
                                                password:(NSString *)password;

/**
 * 未読フィード一覧を取得
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest;


@end
