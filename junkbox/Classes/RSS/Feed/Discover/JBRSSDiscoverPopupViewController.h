#import "TableViewController.h"
#import "JBPopupViewControllerManager.h"


#pragma mark - JBRSSDiscoverPopupViewController
/// URLからRSSフィードを見つけた後、そのフィードを購読するか、購読をやめるか選ぶPopupUI
@interface JBRSSDiscoverPopupViewController : JBPopupViewController {
}


#pragma mark - property
/// popupのメインview
@property (nonatomic, weak) IBOutlet UIView *contentView;
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/// 閉じるボタン
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
/// tableView
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/// フィード一覧
@property (nonatomic, strong) NSMutableArray *feedList;


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


#pragma mark - api
/**
 * JSONのデータ購読リストをセット
 * @param JSON JSON
 */
- (void)setJSON:(NSArray *)JSON;


@end
