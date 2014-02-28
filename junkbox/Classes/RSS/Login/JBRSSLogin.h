#pragma mark - JBRSSLogin
/// RSS Reader Cookie保存
@interface JBRSSLogin : NSObject {
}


#pragma mark - property


#pragma mark - class method
+ (JBRSSLogin *)sharedInstance;


#pragma mark - api
/**
 * 認証が通っているかどうか
 * @return BOOL
 */
- (BOOL)authorized;


@end
