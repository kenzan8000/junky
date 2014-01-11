#pragma mark - constant
#define kJBRSSFeedSubsUnreadTableViewCellHeight 44


#pragma mark - JBRSSFeedSubsUnreadTableViewCell
/// フィード一覧
@interface JBRSSFeedSubsUnreadTableViewCell : UITableViewCell {
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
 * ロード済みか、既読かでデザイン変更
 * @param isFinishedLoading ロード済みか
 * @param isUnread 既読か
 */
- (void)designWithIsFinishedLoading:(BOOL)isFinishedLoading
                           isUnread:(BOOL)isUnread;


@end
