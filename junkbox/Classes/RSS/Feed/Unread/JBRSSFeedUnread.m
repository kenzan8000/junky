#import "JBRSSFeedUnread.h"


#pragma mark - JBRSSFeedUnread
@implementation JBRSSFeedUnread


#pragma mark - synthesize
@synthesize link;
@synthesize body;
@synthesize title;


#pragma mark - release
- (void)dealloc
{
    self.link = nil;
    self.body = nil;
    self.title = nil;
}


@end
