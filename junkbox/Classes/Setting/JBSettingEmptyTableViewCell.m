#import "JBSettingEmptyTableViewCell.h"


#pragma mark - JBSettingEmptyTableViewCell
@implementation JBSettingEmptyTableViewCell


#pragma mark - synthesize


#pragma mark - class method
+ (CGFloat)cellHeight
{
    return kJBSettingEmptyTableViewCellHeight;
}


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
}


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api


@end
