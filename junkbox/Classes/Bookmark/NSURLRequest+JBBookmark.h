#pragma mark - NSURLRequest+JBBookmark
/// NSMutableURLRequest Junkbox拡張(Bookmark API)
@interface NSMutableURLRequest (JBBookmark)


#pragma mark - api
/**
 * Bookmark一覧を取得
 * @return request
 */
+ (NSMutableURLRequest *)JBBookmarkCatalogRequest;


@end
