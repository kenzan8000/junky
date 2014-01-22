#import "TableViewController.h"
#import "JBRSSPinList.h"


#pragma mark - JBReadLaterController
/// あとで読む(PIN)
@interface JBReadLaterController : TableViewController <JBRSSPinListDelegate> {
}


#pragma mark - property
/// PIN一覧
@property (nonatomic, strong) JBRSSPinList *pinList;


@end
