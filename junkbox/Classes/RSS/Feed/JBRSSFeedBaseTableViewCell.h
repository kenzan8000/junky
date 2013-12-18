#import "JBRSSFeedBaseTableViewCell.h"


#pragma mark - JBRSSFeedBaseTableViewCell
/// フィード一覧
@interface JBRSSFeedBaseTableViewCell : UITableViewCell {
}


#pragma mark - property
/// フィード名
@property (nonatomic, weak) IBOutlet UILabel *feedNameLabel;
/// 未読件数
@property (nonatomic, weak) IBOutlet UILabel *unreadCountLabel;


#pragma mark - api
/**
 * フィード名をセット
 * @param feedName feedName
 */
 - (void)setFeedName:(NSString *)feedName;

/**
 * 未読件数をセット
 * @param unreadCount unreadCount
 */
 - (void)setUnreadCount:(NSNumber *)unreadCount;

/**
 * ロード済みかロード中かでデザイン変更
 * @param
 */
- (void)designWithIsLoading:(BOOL)isLoading;

/**
 * 既読か・未読かでデザイン変更
 * @param unread BOOL
 */
- (void)designWithIsUnread:(BOOL)isUnread;


@end
