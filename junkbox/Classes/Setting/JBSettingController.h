#import "TableViewController.h"


#pragma mark - JBSettingController
/// 設定
@interface JBSettingController : TableViewController {
}


#pragma mark - property
/// Cellのクラス一覧
@property (nonatomic, strong) NSArray *cellList;
/// Cellのタイトルラベル一覧
@property (nonatomic, strong) NSArray *cellTitleList;
/// Cellのアイコン一覧
@property (nonatomic, strong) NSArray *cellIconList;


@end
