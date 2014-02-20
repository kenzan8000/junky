#pragma mark - constant
#define kJBSettingTableViewCellHeight 44


#pragma mark - kJBSettingTableViewCell
/// 設定画面Cell
@interface JBSettingTableViewCell : UITableViewCell {
}


#pragma mark - property


#pragma mark - class method
/**
 * cellの高さ
 * @return height
 */
+ (CGFloat)cellHeight;


#pragma mark - api
/**
 * タイトルをセット
 * @param title title
 */
- (void)setTitleWithTitleString:(NSString *)title;

/**
 * 画像をセット
 * @param image image
 */
- (void)setIconWithImage:(UIImage *)image;


@end
