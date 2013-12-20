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
@interface JBRSSFeedSubsUnreadList : NSObject {
}


#pragma mark - property
/// Delegate
@property (nonatomic, weak) id<JBRSSFeedSubsUnreadListDelegate> delegate;
/// 一覧
@property (nonatomic, strong) NSArray *list;


#pragma mark - initializer
/**
 * construct
 * @param delegate delegate
 * @return id
 */
- (id)initWithDelegate:(id<JBRSSFeedSubsUnreadListDelegate>)del;


#pragma mark - api
/**
 * フィード一覧を取得
 */
- (void)loadFeed;

/**
 * 未読フィード数
 * @return count
 */
- (NSInteger)count;

/**
 * 未読フィードを取得
 * @param index index
 * @return unread
 */
- (JBRSSFeedSubsUnread *)unreadWithIndex:(NSInteger)index;


@end
