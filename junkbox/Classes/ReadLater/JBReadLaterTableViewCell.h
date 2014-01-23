#pragma mark - constant
#define kJBReadLaterTableViewCellHeight 44


#pragma mark - JBReadLaterTableViewCell
/// あとで読む(Livedoor Reader PIN)
@interface JBReadLaterTableViewCell : UITableViewCell {
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
