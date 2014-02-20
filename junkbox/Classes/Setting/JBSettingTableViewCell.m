#import "JBSettingTableViewCell.h"


#pragma mark - JBSettingTableViewCell
@implementation JBSettingTableViewCell


#pragma mark - synthesize


#pragma mark - class method
+ (CGFloat)cellHeight
{
    return kJBSettingTableViewCellHeight;
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
- (void)setTitleWithTitleString:(NSString *)title
{
}

- (void)setIconWithImage:(UIImage *)image
{
}


@end
