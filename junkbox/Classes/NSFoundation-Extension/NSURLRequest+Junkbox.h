#pragma mark - NSURLRequest+Junkbox
/// NSMutableURLRequest Junkbox拡張
@interface NSMutableURLRequest (Junkbox)


#pragma mark - api
/**
 * Request
 * @param url url
 * @return request
 */
+ (NSMutableURLRequest *)JBRequestWithURL:(NSURL *)url;

/**
 * POST Request
 * @param url url
 * @return request
 */
+ (NSMutableURLRequest *)JBPostRequestWithURL:(NSURL *)url;

/**
 * POST Request
 * @param url url
 * @param parameters parameters
 * @return request
 */
+ (NSMutableURLRequest *)JBPostRequestWithURL:(NSURL *)url
                                   parameters:(NSDictionary *)parameters;


@end
