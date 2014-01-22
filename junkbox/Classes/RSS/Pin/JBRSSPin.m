#import "JBRSSPin.h"


#pragma mark - JBRSSPin
@implementation JBRSSPin


#pragma mark - dynamic
@dynamic title;
@dynamic link;
@dynamic createdOn;


#pragma mark - release
- (void)dealloc
{
    self.title = nil;
    self.link = nil;
    self.createdOn = nil;
}


@end
