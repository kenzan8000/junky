#pragma mark - UINib+UIKit
/// UI生成
@interface UINib (UIKIt) {
}


#pragma mark - class method
/**
 * クラスからViewを生成
 * @param aClass class
 * @return View
 */
+ (id)UIKitFromClass:(Class)aClass;

/**
 * クラス名からViewを生成
 * @param className クラス名
 * @return View
 */
+ (id)UIKitFromClassName:(NSString *)className;


@end

