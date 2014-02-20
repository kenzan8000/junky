#import "TableViewController.h"


#pragma mark - JBSettingController
/// 設定
@interface JBSettingController : TableViewController {
}


#pragma mark - property
/// Cellのクラス
@property (nonatomic, strong) NSArray *cellClassList;
/// Cellのタイトル
@property (nonatomic, strong) NSArray *cellTitleList;
/// Cellのアイコン
@property (nonatomic, strong) NSArray *cellIconList;

/// セクションのタイトル
@property (nonatomic, strong) NSArray *sectionTitleList;
/// セクションのアイコン
@property (nonatomic, strong) NSArray *sectionIconList;


@end