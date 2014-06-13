#import "JBBarButtonView.h"


#pragma mark - class
@class JBQBFlatButton;
@class YLImageView;


#pragma mark - JBHintViewController
/// ヒント
@interface JBHintViewController : UIViewController <JBBarButtonViewDelegate> {
}


#pragma mark - property
/// ナビゲーションバー前の画面へ戻るボタン
@property (nonatomic, strong) JBBarButtonView *backButtonView;
/// ヒントの種類
@property (nonatomic, strong) NSString *hint;

/// ヒント再生ボタン
@property (nonatomic, weak) IBOutlet JBQBFlatButton *playButton;
/// ヒントGIFアニメ
@property (nonatomic, strong) YLImageView *hintImageView;


#pragma mark - event listner
- (IBAction)touchedUpInsideWithButton:(UIButton *)button;


@end
