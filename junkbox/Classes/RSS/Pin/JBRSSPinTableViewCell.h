#pragma mark - constant
#define kJBRSSPinTableViewCellHeight 54


#pragma mark - JBRSSPinTableViewCell
/// あとで読む(Livedoor Reader PIN)
@interface JBRSSPinTableViewCell : UITableViewCell {
}


#pragma mark - property
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *titleNameLabel;


#pragma mark - api
/**
 * タイトルをセット
 * @param titleName titleName
 */
 - (void)setTitleName:(NSString *)titleName;


@end
