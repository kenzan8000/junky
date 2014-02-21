#import "JBSettingTableViewCell.h"


#pragma mark - class
@class JBQBFlatButton;
@class SSGentleAlertView;
@class JBSettingSocialTableViewCell;


#pragma mark - JBSettingSocialTableViewCellDelegate
/// JBSettingSocialTableViewCellDelegate
@protocol JBSettingSocialTableViewCellDelegate <NSObject>


/**
 * presentViewControllerするためのDelegate
 * @param vc presentするvc
 * @param cell JBSettingSocialTableViewCell
 */
- (void)presentViewController:(UIViewController *)vc
                         cell:(JBSettingSocialTableViewCell *)cell;


@end


#pragma mark - constant
#define kJBSettingSocialTableViewCellHeight 80


#pragma mark - JBSettingSocialTableViewCell
/// ソーシャル関連のCell
@interface JBSettingSocialTableViewCell : JBSettingTableViewCell {
}


#pragma mark - property
/// ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *reviewButton;

/// Delegate
@property (nonatomic, weak) id<JBSettingSocialTableViewCellDelegate> delegate;

#pragma mark - event listener
/**
 * ボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


@end
