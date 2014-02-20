#import "JBSettingHintTableViewCell.h"


#pragma mark - JBSettingHintTableViewCell
@implementation JBSettingHintTableViewCell


#pragma mark - synthesize
@synthesize iconImageView;
@synthesize titleLabel;


#pragma mark - class method
+ (CGFloat)cellHeight
{
    return kJBSettingHintTableViewCellHeight;
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
    [self.titleLabel setText:title];
}

- (void)setIconWithImage:(UIImage *)image
{
    [self.iconImageView setImage:image];
}


@end

