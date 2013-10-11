#pragma mark - NSString+PercentEncoding
/// パーセントエンコーディング
@interface NSString (PercentEncoding)


#pragma mark - api
- (NSString *)escapeString;

- (NSString *)encodeURIString;

- (NSString *)encodeURIComponentString;

- (NSString *)decodeURIComponentString;


@end
