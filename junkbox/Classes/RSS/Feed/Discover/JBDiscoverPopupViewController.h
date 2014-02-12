#import "TableViewController.h"
#import "JBPopupViewControllerManager.h"


#pragma mark - JBDiscoverPopupViewController
/// URLからRSSフィードを見つけた後、そのフィードを購読するか、購読をやめるか選ぶPopupUI
@interface JBDiscoverPopupViewController : JBPopupViewController {
}


#pragma mark - property
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



@end
