#pragma mark - class
@class JBRSSDiscover;
@class JBQBFlatButton;


#pragma mark - constant
#define JBRSSDiscoverTableViewCellHeight 128


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
/// 購読ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *subscribeButton;
/// 購読停止ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *unsubscribeButton;


#pragma mark - event listner
/**
 * ボタン押下
 * @param button button
 * @return IBAction
 */
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


#pragma mark - api
/**
 * フィード情報をセット
 * @param discover フィード情報
 */
- (void)setDiscover:(JBRSSDiscover *)discover;


@end
