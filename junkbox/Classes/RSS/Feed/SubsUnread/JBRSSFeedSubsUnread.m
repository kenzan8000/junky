#import "JBRSSFeedSubsUnread.h"


#pragma mark - JBRSSFeedSubsUnread
@implementation JBRSSFeedSubsUnread


#pragma mark - dynamic
@dynamic subscribeId;
@dynamic title;
@dynamic unreadCount;
@dynamic rate;
@dynamic folder;
@dynamic feedlink;
@dynamic link;
@dynamic icon;


#pragma mark - release
- (void)dealloc
{
    self.subscribeId = nil;
    self.title = nil;
    self.unreadCount = nil;
    self.rate = nil;
    self.folder = nil;
    self.feedlink = nil;
    self.link = nil;
    self.icon = nil;
}


@end
