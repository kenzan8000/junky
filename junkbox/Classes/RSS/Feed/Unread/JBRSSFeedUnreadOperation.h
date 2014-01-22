#import "JBRSSOperation.h"


#pragma mark - JBRSSFeedUnreadOperation
/// フィード詳細
@interface JBRSSFeedUnreadOperation : JBRSSOperation {
}


#pragma mark - property
/// フィードのsubscribeId
@property (nonatomic, strong) NSString *subscribeId;


#pragma mark - initializer
/**
 * construct
 * @param subscribeId フィードのsubscribeId
 * @param handler handler
 * @return id
 */
- (id)initWithSubscribeId:(NSString *)subscribeId
                  handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;


#pragma mark - api
/**
 * WebAPIのURLを返す
 * @return URL
 */
- (NSURL *)APIURL;


@end
