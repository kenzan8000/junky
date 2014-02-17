#pragma mark - class
@class JBRSSDiscover;
@class NKToggleOverlayButton;
@class JBRSSDiscoverTableViewCell;
@class JBOutlineLabel;


#pragma mark - constant
#define JBRSSDiscoverTableViewCellHeight 92


#pragma mark - JBRSSDiscoverTableViewCellDelegate
/// JBRSSDiscoverTableViewCellDelegate
@protocol JBRSSDiscoverTableViewCellDelegate <NSObject>


/**
 * レイティングボタンを押した
 * @param cell JBRSSDiscoverTableViewCell
 */
- (void)ratingButtonDidTouchedUpInsideWithCell:(JBRSSDiscoverTableViewCell *)cell;


@end


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
/// フィードレイティングボタン
@property (nonatomic, weak) IBOutlet UIButton *ratingButton;
/// フィードレイティングスター
@property (nonatomic, weak) IBOutlet JBOutlineLabel *ratingLabel;
/// 購読ボタン位置の参考のためのUIView
@property (nonatomic, weak) IBOutlet UIView *subscribeButtonView;
/// 購読ボタン
@property (nonatomic, strong) NKToggleOverlayButton *subscribeButton;
/// Delegate
@property (nonatomic, weak) id<JBRSSDiscoverTableViewCellDelegate> delegate;


#pragma mark - event listner
/**
 * ボタン押下
 * @param button button
 */
- (IBAction)touchedDownWithButton:(UIButton *)button;


#pragma mark - api
/**
 * フィード情報をセット
 * @param discover フィード情報
 */
- (void)setDiscover:(JBRSSDiscover *)discover;


@end
