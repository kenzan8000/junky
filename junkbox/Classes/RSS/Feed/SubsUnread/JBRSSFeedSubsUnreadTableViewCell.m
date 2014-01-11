#import "JBRSSFeedSubsUnreadTableViewCell.h"
/// UIKit-Extension
#import "UIColor+Hexadecimal.h"


#pragma mark - JBRSSFeedSubsUnreadTableViewCell
@implementation JBRSSFeedSubsUnreadTableViewCell


#pragma mark - synthesize
@synthesize feedNameLabel;
@synthesize unreadCountLabel;


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


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

- (void)designWithIsFinishedLoading:(BOOL)isFinishedLoading
                           isUnread:(BOOL)isUnread
{
    // ロード済み
    if (isFinishedLoading) {
        // 未読
        if (isUnread) {
            self.feedNameLabel.textColor = [UIColor colorWithHexadecimal:0x3b78e1ff];
            self.unreadCountLabel.textColor = [UIColor colorWithHexadecimal:0x3b78e1ff];
        }
        // 既読
        else {
            self.feedNameLabel.textColor = [UIColor colorWithHexadecimal:0x4b4b4bff];
            self.unreadCountLabel.textColor = [UIColor colorWithHexadecimal:0x4b4b4bff];
            self.unreadCountLabel.text = @"";
        }
    }
    else {
        self.feedNameLabel.textColor = [UIColor colorWithHexadecimal:0x4b4b4bff];
        self.unreadCountLabel.textColor = [UIColor colorWithHexadecimal:0x4b4b4bff];
    }
}


@end
