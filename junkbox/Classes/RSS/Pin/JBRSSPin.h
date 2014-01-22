#import <CoreData/NSManagedObject.h>


#pragma mark - JBRSSPin
/// あとで読む(Livedoor Reader PIN)
@interface JBRSSPin : NSManagedObject {
}


#pragma mark - property
/// タイトル
@property (nonatomic, strong) NSString *title;
/// リンク
@property (nonatomic, strong) NSString *link;
/// ID
@property (nonatomic, strong) NSString *createdOn;


@end
