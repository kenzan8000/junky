#pragma mark - NSURL+Query
/// URLのクエリ文字列処理
@interface NSURL (Query)


#pragma mark - api
/**
 * クエリ付きURLを生成
 * @param URLString baseURL文字列
 * @param queries クエリ
 * @return クエリ付きURL
 */
+ (NSURL *)URLWithString:(NSString *)URLString
                 queries:(NSDictionary *)queries;

/**
 * URLのクエリを連想配列にする
 * @return クエリ
 */
- (NSDictionary *)queries;


@end
