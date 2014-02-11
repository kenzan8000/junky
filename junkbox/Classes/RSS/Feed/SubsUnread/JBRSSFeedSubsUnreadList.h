#import "JBModelList.h"


#pragma mark - class
@class JBRSSFeedSubsUnreadList;
@class JBRSSFeedSubsUnread;


#pragma mark - JBRSSFeedSubsUnreadListDelegate
/// JBRSSFeedSubsUnreadListDelegate
@protocol JBRSSFeedSubsUnreadListDelegate <NSObject>


/**
 * 未読フィード一覧取得成功
 * @param list 一覧
 */
- (void)feedDidFinishLoadWithList:(JBRSSFeedSubsUnreadList *)list;

/**
 * 未読フィード一覧取得失敗
 * @param error error
 */
- (void)feedDidFailLoadWithError:(NSError *)error;


@end


#pragma mark - JBRSSFeedSubsUnreadList
/// 未読フィード一覧
@interface JBRSSFeedSubsUnreadList : JBModelList {
}


#pragma mark - property
/// Delegate
@property (nonatomic, weak) id<JBRSSFeedSubsUnreadListDelegate> delegate;
/// レイティングとそのレイティングに該当したフィード数(配列の添字が0のときmax, 配列.lengthのとき0)
@property (nonatomic, strong) NSArray *feedCountOfEachRate;


#pragma mark - initializer
/**
 * construct
 * @param delegate delegate
 * @return id
 */
- (id)initWithDelegate:(id<JBRSSFeedSubsUnreadListDelegate>)del;


#pragma mark - api
/**
 * WebAPIからフィードをロード
 */
- (void)loadFeedFromWebAPI;

/**
 * ローカルに保存されていたフィードをロード
 */
- (void)loadFeedFromLocal;

/**
 * フィード数を取得
 * @param rate レイティング
 * @return feedCount
 */
- (NSInteger)feedCountWithRate:(NSInteger)rate;

/**
 * 未読フィードを取得
 * @param index index
 * @return unread
 */
- (JBRSSFeedSubsUnread *)unreadWithIndex:(NSInteger)index;

/**
 * 未読フィードを取得
 * @param indexPath indexPath
 * @return unread
 */
- (JBRSSFeedSubsUnread *)unreadWithIndexPath:(NSIndexPath *)indexPath;

/**
 * 未読フィードのcellが何番目か
 * @param indexPath indexPath
 * @return integer
 */
- (NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath;

/**
 * 未読フィードのcellのindexPath
 * @param index index
 * @return indexPath
 */
- (NSIndexPath *)indexPathWithIndex:(NSInteger)index;


@end
