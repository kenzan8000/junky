#import "JBSettingTableViewCell.h"


#pragma mark - constant
#define JBSettingHeaderTableViewCellHeight 28


#pragma mark - JBSettingHeaderTableViewCell
/// ヘッダー
@interface JBSettingHeaderTableViewCell : JBSettingTableViewCell {
}


#pragma mark - property
/// アイコン
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


@end
