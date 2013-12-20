#import <CoreData/NSManagedObject.h>


#pragma mark - JBRSSFeedSubsUnread
/// 未読フィード
@interface JBRSSFeedSubsUnread : NSManagedObject {
}


#pragma mark - property
/// ID (on Livedoor Reader case -> subscribe_id)
@property (nonatomic, strong) NSString *subscribeId;
/// フィード名
/// 未読件数
/// フィード評価(スター)


@end
