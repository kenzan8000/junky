#import "JBModelList.h"


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

/**
 * あとで読む(Livedoor Reader PIN)を削除した
 * @param list 一覧
 * @param link 削除したリンク
 * @param index 削除した行
 */
- (void)pinDidDeleteWithList:(JBRSSPinList *)list
                        link:(NSString *)link
                       index:(NSInteger)index;


@end


#pragma mark - JBRSSPinList
/// 未読フィード一覧
@interface JBRSSPinList : JBModelList {
}


#pragma mark - property
/// Delegate
@property (nonatomic, weak) id<JBRSSPinListDelegate> delegate;


#pragma mark - class method
/**
 * Singleton
 * @return JBRSSPinList
 */
+ (JBRSSPinList *)sharedInstance;


#pragma mark - api
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

/**
 * PIN削除
 * @param link link
 */
- (void)removePinWithLink:(NSString *)link;


@end
