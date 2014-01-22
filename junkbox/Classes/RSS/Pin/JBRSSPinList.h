#pragma mark - class
@class JBRSSPin;
@class JBRSSPinList;


#pragma mark - JBRSSPinListDelegate
/// JBRSSPinListDelegate
@protocol JBRSSPinListDelegate <NSObject>


/**
 * あとで読む(Livedoor Reader PIN)一覧取得成功
 * @param list 一覧
 */
- (void)pinDidFinishLoadWithList:(JBRSSPinList *)list;

/**
 * あとで読む(Livedoor Reader PIN)一覧取得失敗
 * @param error error
 */
- (void)pinDidFailLoadWithError:(NSError *)error;


@end


#pragma mark - JBRSSPinList
/// 未読フィード一覧
@interface JBRSSPinList : NSObject {
}


#pragma mark - property
/// Delegate
@property (nonatomic, weak) id<JBRSSPinListDelegate> delegate;
/// 一覧
@property (nonatomic, strong) NSMutableArray *list;


#pragma mark - class method
/**
 * Singleton
 * @return JBRSSPinList
 */
+ (JBRSSPinList *)sharedInstance;


#pragma mark - initializer
/**
 * construct
 * @param delegate delegate
 * @return id
 */
- (id)initWithDelegate:(id<JBRSSPinListDelegate>)del;


#pragma mark - api
/**
 * List数
 * @return count
 */
- (NSInteger)count;

/**
 * PINを取得
 * @param index index
 * @return unread
 */
- (JBRSSPin *)pinWithIndex:(NSInteger)index;

/**
 * WebAPIからPINをロード
 */
- (void)loadAllPinFromWebAPI;

/**
 * ローカルに保存されていたPINをロード
 */
- (void)loadAllPinFromLocal;

/**
 * PIN追加
 * @param title title
 * @param link link
 */
- (void)addPinWithTitle:(NSString *)title
                   link:(NSString *)link;


@end
