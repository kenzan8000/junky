#import "TableViewController.h"
#import "JBRSSPinList.h"
#import "JBBarButtonView.h"


#pragma mark - JBRSSPinController
/// あとで読む(PIN)
@interface JBRSSPinController : TableViewController <JBRSSPinListDelegate, JBBarButtonViewDelegate> {
}


#pragma mark - property
/// PIN一覧
@property (nonatomic, strong) JBRSSPinList *pinList;
/// ログインボタン
@property (nonatomic, strong) JBBarButtonView *loginButtonView;


@end
