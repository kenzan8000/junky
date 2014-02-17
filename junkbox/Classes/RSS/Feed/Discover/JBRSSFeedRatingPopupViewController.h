#import "JBPopupViewControllerManager.h"
// Pods
#import "EDStarRating.h"


#pragma mark - class
@class JBRSSFeedRatingPopupViewController;


#pragma mark - JBRSSFeedRatingPopupViewControllerDelegate
/// JBRSSFeedRatingPopupViewControllerDelegate
@protocol JBRSSFeedRatingPopupViewControllerDelegate <NSObject>


/**
 * レイティングを設定した
 * @param rating 設定したレイティング
 * @param row 選択したcell
 * @param RSSFeedRatingPopupViewController JBRSSFeedRatingPopupViewController
 */
- (void)feedRatingDidFinishedWithRating:(NSInteger)rating
                                    row:(NSInteger)row
          feedRatingPopupViewController:(JBRSSFeedRatingPopupViewController *)RSSFeedRatingPopupViewController;


@end


#pragma mark - JBRSSFeedRatingPopupViewController
/// RSSフィードレイティング
@interface JBRSSFeedRatingPopupViewController : JBPopupViewController <EDStarRatingProtocol> {
}


#pragma mark - property
/// View
@property (nonatomic, weak) IBOutlet UIView *contentView;
/// レイティング
@property (nonatomic, weak) IBOutlet EDStarRating *ratingControl;
/// 閉じるボタン
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

/// 中心位置
@property (nonatomic, assign) CGPoint center;
/// レイティング
@property (nonatomic, assign) NSInteger rating;
/// 選択したrow
@property (nonatomic, assign) NSInteger row;

/// Delegate
@property (nonatomic, weak) id<JBRSSFeedRatingPopupViewControllerDelegate> delegate;


#pragma mark - event listner
/**
 * ボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


#pragma mark - api
/**
 * 表示位置をセット
 * @param cell タップしたセル
 * @param tableView tableView
 */
- (void)setFrameFromCell:(UITableViewCell *)cell
               tableView:(UITableView *)tableView;



@end
