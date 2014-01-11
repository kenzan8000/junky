#pragma mark - JBRSSFeedUnread
/// フィード詳細リストの詳細
@interface JBRSSFeedUnread : NSObject {
}


#pragma mark - property
/// リンク
@property (nonatomic, strong) NSURL *link;
/// 簡易表示のためのbodyString
@property (nonatomic, strong) NSString *body;
/// タイトル
@property (nonatomic, strong) NSString *title;


@end
