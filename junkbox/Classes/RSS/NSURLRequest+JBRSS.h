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

/**
 * フィードを既読化
 * @param subscribeId フィードのsubscribeId
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSTouchAllRequestWithSubscribeId:(NSString *)subscribeId;

/**
 * URLからフィードを探す
 * @param URL URL
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSFeedDiscoverRequestWithURL:(NSURL *)URL;

/**
 * フィードを登録する
 * @param URL feedlink
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSFeedSubscribeRequestWithURL:(NSURL *)URL;

/**
 * フィードのレイティングを変更する
 * @param subscribeId subscribeId
 * @param rate rate
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSFeedSetRateRequestWithSubscribeId:(NSString *)subscribeId
                                                           rate:(NSNumber *)rate;

/*
 * Livedoor ReaderのPinにリンクを追加
 * @param pinTitle pinTitleの名前でpinに追加される
 * @param pinLink pinに追加されるURL
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSAddPinRequestWithTitle:(NSString *)title
                                                link:(NSString *)link;
/*
 * Livedoor ReaderのPinにリンクを削除
 * @param link pinに追加されるURL
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSRemovePinRequestWithLink:(NSString *)link;

/**
 * Livedoor Readerのピン一覧取得
 * @return request
 */
+ (NSMutableURLRequest *)JBRSSPinAllRequest;


@end
