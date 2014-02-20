#import "JBSettingTableViewCell.h"


#pragma mark - constant
#define kJBSettingLicenceTableViewCellHeight 54


#pragma mark - JBSettingLicenceTableViewCell
/// アプリのライセンス情報
@interface JBSettingLicenceTableViewCell : JBSettingTableViewCell {
}


#pragma mark - property
/// アイコン
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


@end
