#pragma mark - interface
/// 16進数対応UIColor
@interface UIColor (Hexadecimal)


#pragma mark - api
/**
 * 16進数整数からUIColorを生成
 * @param hexadecimal RRGGBBAA
 * @return UIColor
 */
+ (UIColor *)colorWithHexadecimal:(NSInteger)hexadecimal;


@end
