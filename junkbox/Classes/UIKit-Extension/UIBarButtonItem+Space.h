#pragma mark - UIBarButtonItem+Space
/// UIBarButtonItem makes plus or negative space
@interface UIBarButtonItem (Space) {
}


#pragma mark - class method
/**
 * UIBarButtonSystemItemFixedSpaceのUIBarButtonItemを生成
 * @param width 幅(Plus of Minus)
 * @return UIBarButtonItem
 */
+ (UIBarButtonItem *)spaceBarButtonItemWithWidth:(CGFloat)width;


@end

