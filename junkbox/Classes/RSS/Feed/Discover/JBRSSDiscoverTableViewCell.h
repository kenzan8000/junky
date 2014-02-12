#pragma mark - class
@class JBRSSDiscover;
@class NKToggleOverlayButton;


#pragma mark - constant
#define JBRSSDiscoverTableViewCellHeight 72


#pragma mark - JBRSSDiscoverTableViewCell
/// 登録するフィードを選んでください
@interface JBRSSDiscoverTableViewCell : UITableViewCell {
}


#pragma mark - property
/// フィードタイトル
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/// フィード購読者数
@property (nonatomic, weak) IBOutlet UILabel *subscribersCountLabel;
/// フィードlink
@property (nonatomic, weak) IBOutlet UILabel *linkLabel;
/// 購読ボタン位置の参考のためのUIView
@property (nonatomic, weak) IBOutlet UIView *subscribeButtonView;
/// 購読ボタン
@property (nonatomic, strong) NKToggleOverlayButton *subscribeButton;


#pragma mark - event listner


#pragma mark - api
/**
 * 購読ボタンをトグルさせる
 */
- (void)toggleIsOn;

/**
 * フィード情報をセット
 * @param discover フィード情報
 */
- (void)setDiscover:(JBRSSDiscover *)discover;


@end
