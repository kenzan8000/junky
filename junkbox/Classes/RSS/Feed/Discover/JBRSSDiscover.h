#pragma mark - JBRSSDiscover
/// 登録するフィード
@interface JBRSSDiscover : NSObject {
}


#pragma mark - property
/// RSS Feedのlink
@property (nonatomic, strong) NSURL *feedlink;
/// Feedのlink
@property (nonatomic, strong) NSURL *link;
/// 購読ID
@property (nonatomic, strong) NSString *subscribeId;
/// 購読者数
@property (nonatomic, assign) NSInteger subscribersCount;
/// Feed title
@property (nonatomic, strong) NSString *title;


#pragma mark - class method
/**
 * JSONから登録するフィードのNSMutableArrayを生成
 * @param JSON JSON
 * @return list
 */
+ (NSMutableArray *)JBRSSDiscoverListWithJSON:(NSArray *)JSON;


#pragma mark - api


@end
