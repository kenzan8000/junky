#import "JBRSSFeedUnreadList.h"


#pragma mark - class
@class JBRSSFeedSubsUnreadList;


#pragma mark - JBRSSFeedUnreadLists
/// フィード詳細リストのリスト
@interface JBRSSFeedUnreadLists : NSObject {
}


#pragma mark - property
/// 詳細リストのリスト
@property (nonatomic, strong) NSMutableArray *list;


#pragma mark - initializer
/**
 * construct
 * @param subsUnreadList JBRSSFeedSubsUnreadList
 * @param listsDelegate 詳細画面用
 * @return id
 */
- (id)initWithSubsUnreadList:(JBRSSFeedSubsUnreadList *)subsUnreadList
               listsDelegate:(id<JBRSSFeedUnreadListsDelegate>)listsDelegate;

#pragma mark - api
/**
 * listの配列indexを指定してフィード詳細を先読み
 * @param index index
 */
- (void)loadWithIndex:(NSInteger)index;

/**
 * listの配列indexを指定してフィード詳細を先読み停止
 * @param index index
 */
- (void)stopLoadingWithIndex:(NSInteger)index;

/**
 * フィード詳細をロード
 * @param unreadList フィード詳細
 */
- (void)loadWithUnreadList:(JBRSSFeedUnreadList *)unreadList;

/**
 * フィード詳細をロード停止
 * @param unreadList フィード詳細
 */
- (void)stopLoadWithUnreadList:(JBRSSFeedUnreadList *)unreadList;

/**
 * すべてのフィード詳細をロード停止
 */
- (void)stopAllLoading;

/**
 * listの配列のindexを指定してlistを取得
 * @param index
 * @return list
 */
- (JBRSSFeedUnreadList *)listWithIndex:(NSInteger)index;

/**
 * listが何番目のリストか
 * @param list
 * @return index(index範囲外の場合-1を返す)
 */
- (NSInteger)indexWithList:(JBRSSFeedUnreadList *)unreadList;

/**
 * listの配列数
 * return count
 */
- (NSInteger)count;


@end
