#pragma mark - NSURLRequest+JBRSS
/// NSMutableURLRequest Junkbox拡張(RSS Reader API)
@interface NSMutableURLRequest (JBRSS)


#pragma mark - api
/**
 * ログイン
 * @param livedoorID livedoorID
 * @param password passowrd
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSLoginRequest1WithLivedoorID:(NSString *)livedoorID
                                                 password:(NSString *)password;

+ (NSMutableURLRequest *)JBRSSLoginRequest2WithLivedoorID:(NSString *)livedoorID
                                                 password:(NSString *)password;

+ (NSMutableURLRequest *)JBRSSLoginRequest3WithLivedoorID:(NSString *)livedoorID
                                                 password:(NSString *)password;

/**
 * 未読フィード一覧を取得
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSSubsUnreadRequest;


/**
 * フィードの記事一覧を取得
 * @param subscribeId フィードのsubscribeId
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSUnreadRequestWithSubscribeId:(NSString *)subscribeId;

/*
 * LivedoorのPinにリンクを追加
 * @param pinTitle pinTitleの名前でpinに追加される
 * @param pinLink pinに追加されるURL
 */
+ (NSMutableURLRequest *)JBRSSAddPinRequestWithTitle:(NSString *)title
                                                link:(NSString *)link;


@end
