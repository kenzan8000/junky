#import "JBModelList.h"


#pragma mark - class
@class JBBookmarkList;


#pragma mark - JBBookmarkListDelegate
/// JBBookmarkListDelegate
@protocol JBBookmarkListDelegate <NSObject>


/**
 * Bookmark一覧取得成功
 * @param list 一覧
 */
- (void)bookmarkListDidFinishLoadWithList:(JBBookmarkList *)list;

/**
 * Bookmark一覧取得失敗
 * @param error error
 */
- (void)bookmarkListDidFailLoadWithError:(NSError *)error;


@end


#pragma mark - JBBookmarkList
/// Bookmark一覧
@interface JBBookmarkList : JBModelList {
}


#pragma mark - property
/// Delegate
@property (nonatomic, weak) id<JBBookmarkListDelegate> delegate;


#pragma mark - class method
+ (JBBookmarkList *)sharedInstance;


#pragma mark - initializer


#pragma mark - api
/**
 * WebAPIからロード
 */
- (void)loadFromWebAPI;

/**
 * ローカルからロード
 */
- (void)loadFromLocal;


@end
