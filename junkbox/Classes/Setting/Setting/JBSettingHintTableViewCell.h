#import "JBSettingTableViewCell.h"


#pragma mark - constant
#define kJBSettingHintTableViewCellHeight 54


#pragma mark - JBSettingHintTableViewCell
/// アプリ操作のヒント
@interface JBSettingHintTableViewCell : JBSettingTableViewCell {
}


#pragma mark - property
/// アイコン
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


@end
