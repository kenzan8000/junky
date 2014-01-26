#import "TableViewController.h"
#import "JBRSSPinList.h"


#pragma mark - JBRSSPinController
/// あとで読む(PIN)
@interface JBRSSPinController : TableViewController <JBRSSPinListDelegate> {
}


#pragma mark - property
/// PIN一覧
@property (nonatomic, strong) JBRSSPinList *pinList;


@end
