#import "JBReadLaterTableViewCell.h"


#pragma mark - JBReadLaterTableViewCell
@implementation JBReadLaterTableViewCell


#pragma mark - synthesize
@synthesize titleNameLabel;


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
 - (void)setTitleName:(NSString *)t
{
    [self.titleNameLabel setText:t];
}


@end
