#import "JBRSSFeedSubsUnreadTableViewCell.h"


#pragma mark - JBRSSFeedSubsUnreadTableViewCell
@implementation JBRSSFeedSubsUnreadTableViewCell


#pragma mark - synthesize
@synthesize feedNameLabel;
@synthesize unreadCountLabel;


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api
 - (void)setFeedName:(NSString *)feedName
{
    self.feedNameLabel.text = feedName;
}

- (void)setUnreadCount:(NSNumber *)unreadCount
{
    self.unreadCountLabel.text = [NSString stringWithFormat:@"%@", unreadCount];
}

- (void)designWithIsLoading:(BOOL)isLoading
{
    if (isLoading) {
    }
    else {
    }
}

- (void)designWithIsUnread:(BOOL)isUnread
{
    if (isUnread) {
    }
    else {
    }
}


@end
