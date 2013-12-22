#import <CoreData/NSManagedObject.h>


#pragma mark - JBRSSFeedSubsUnread
/// 未読フィード
@interface JBRSSFeedSubsUnread : NSManagedObject {
}


#pragma mark - property
/// subscribe_id (Livedoor Reader)
@property (nonatomic, strong) NSString *subscribeId;
/// フィード名
@property (nonatomic, strong) NSString *title;
/// 未読件数
@property (nonatomic, strong) NSNumber *unreadCount;
/// スター (Livedoor Reader)
@property (nonatomic, strong) NSNumber *rate;
/// フォルダ (Livedoor Reader)
@property (nonatomic, strong) NSString *folder;
/// フィードのatom,rssのリンク
@property (nonatomic, strong) NSString *feedlink;
/// フィードのリンク
@property (nonatomic, strong) NSString *link;
/// ファビコンなどのアイコン
@property (nonatomic, strong) NSString *icon;


@end
