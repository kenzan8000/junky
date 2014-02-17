#pragma mark - JBOutlineLabel
/// 縁取り文字Label
@interface JBOutlineLabel : UILabel {
}


#pragma mark - property
/// 縁取り色
@property (nonatomic, strong) UIColor *outlineColor;
/// 縁取り太さ
@property (nonatomic, assign) CGFloat outlineWidth;


#pragma mark - api
/**
 * 画像を生成
 * @retun image
 */
- (UIImage *)image;


@end
