#pragma mark - JBRSSLoginTask
/// ログイン画面
@interface JBRSSLoginTask : NSObject {
}


#pragma mark - property


#pragma mark - api (Livedoor Reader)
/**
 * livedoor reader にログイン
 * @param livedoorID livedoorID
 * @param password password
 * @param handler ログイン処理完了(error: nil->成功, the others->失敗)
 */
-(void)livedoorReaderLoginWithLivedoorID:(NSString *)livedoorID
                                password:(NSString *)password
                                 handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;


@end
