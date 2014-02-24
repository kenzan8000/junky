#pragma mark - class
@class JBRSSFeedUnreadList;
@class JBRSSFeedUnread;
@class JBRSSFeedUnreadOperation;


#pragma mark - JBRSSFeedUnreadListDelegate
/// JBRSSFeedUnreadListDelegate -> 詳細画面用
@protocol JBRSSFeedUnreadListDelegate <NSObject>


/**
 * フィード詳細一覧取得成功
 * @param list 一覧
 */
- (void)unreadListDidFinishLoadWithList:(JBRSSFeedUnreadList *)list;

/**
 * フィード詳細一覧取得失敗
 * @param error error
 */
- (void)unreadListDidFailLoadWithError:(NSError *)error;


@end


/// JBRSSFeedUnreadListsDelegate -> 一覧画面用
@protocol JBRSSFeedUnreadListsDelegate <NSObject>


/**
 * フィード詳細一覧取得成功
 * @param list 一覧
 */
- (void)unreadListsDidFinishLoadWithList:(JBRSSFeedUnreadList *)list;

/**
 * フィード詳細一覧取得失敗
 * @param list 一覧
 * @param error error
 */
- (void)unreadListsDidFailLoadWithError:(NSError *)error
                                   list:(JBRSSFeedUnreadList *)list;


@end


#pragma mark - JBRSSFeedUnreadList
/// フィード詳細リスト
@interface JBRSSFeedUnreadList : NSObject {
}


#pragma mark - property
/// Delegate -> 詳細画面用
@property (nonatomic, weak) id<JBRSSFeedUnreadListDelegate> listDelegate;
/// Delegate -> 一覧画面用
@property (nonatomic, weak) id<JBRSSFeedUnreadListsDelegate> listsDelegate;
/// 詳細リスト
@property (nonatomic, strong) NSMutableArray *list;
/// フィード詳細リストロード処理
@property (nonatomic, strong) JBRSSFeedUnreadOperation *operation;
/// 未読かどうか
@property (nonatomic, assign) BOOL isUnread;


#pragma mark - initializer
/**
 * construct
 * @param subscribeId フィードのsubscribeId
 * @param listDelegate 詳細画面用
 * @param listsDelegate 一覧画面用
 * @return id
 */
- (id)initWithSubscribeId:(NSString *)subscribeId
             listDelegate:(id<JBRSSFeedUnreadListDelegate>)listDelegate
            listsDelegate:(id<JBRSSFeedUnreadListsDelegate>)listsDelegate;


#pragma mark - api
/**
 * WebAPIからをロード
 */
- (void)loadFeedFromWebAPI;

/**
 * WebAPIからのロードを中止
 */
- (void)stopLoadingFeedFromWebAPI;

/**
 * NSOperationQueueで管理している通信operationの優先順位を変える
 * @param priority 優先順位
 */
- (void)setOperationQueuePriority:(NSOperationQueuePriority)priority;

/**
 * 詳細リストの数
 * @return count
 */
- (NSInteger)count;

/**
 * 詳細を取得
 * @param index index
 * @return 詳細
 */
- (JBRSSFeedUnread *)unreadWithIndex:(NSInteger)index;

/**
 * 詳細を読み込み中かどうか
 * @return BOOL
 */
- (BOOL)isFinishedLoading;


@end
