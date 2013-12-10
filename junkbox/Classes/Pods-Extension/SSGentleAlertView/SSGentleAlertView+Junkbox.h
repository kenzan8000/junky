/// Pods
#import "SSGentleAlertView.h"


#pragma mark - SSGentleAlertView+Junkbox
/// SSGentleAlertViewのJunkbox拡張
@interface SSGentleAlertView (Junkbox)


#pragma mark - api
/**
 * アラート表示
 * @param message アラートメッセージ
 * @param buttonTitles アラートボタンタイトル
 * @param delegate delegate
 */
+ (void)showWithMessage:(NSString *)message
           buttonTitles:(NSArray *)buttonTitles
               delegate:(id)delegate;


@end
