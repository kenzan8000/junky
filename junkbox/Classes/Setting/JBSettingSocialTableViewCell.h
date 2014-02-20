#import "JBSettingTableViewCell.h"


#pragma mark - class
@class JBQBFlatButton;
@class SSGentleAlertView;


#pragma mark - constant
#define kJBSettingSocialTableViewCellHeight 80


#pragma mark - JBSettingSocialTableViewCell
/// レビュー
@interface JBSettingSocialTableViewCell : JBSettingTableViewCell {
}


#pragma mark - property
/// レビューボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *reviewButton;


#pragma mark - event listener
/**
 * ボタン押下
 * @param button button
 */
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


@end
