#import "JBBookmarkOperation.h"


#pragma mark - JBBookmarkCatalogOperation
/// Bookmark一覧取得
@interface JBBookmarkCatalogOperation : JBBookmarkOperation {
}


#pragma mark - property


#pragma mark - initializer
/**
 * construct
 * @param handler handler
 * @return id
 */
- (id)initWithHandler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))h;


@end
