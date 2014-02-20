#import "JBBarButtonView.h"


#pragma mark - JBLicenceViewController
/// ライセンス情報
@interface JBLicenceViewController : UIViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// ナビゲーションバー前の画面へ戻るボタン
@property (nonatomic, strong) JBBarButtonView *backButtonView;
/// TextView
@property (nonatomic, weak) IBOutlet UITextView *licenceTextView;


@end
