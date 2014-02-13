#import "JBBookmarkCatalogTableViewCell.h"
#import "JBBookmark.h"


#pragma mark - JBBookmarkCatalogTableViewCell
@implementation JBBookmarkCatalogTableViewCell


#pragma mark - synthesize
@synthesize bookmarkTitleLabel;
@synthesize bookmarkTagsLabel;
@synthesize bookmarkDateLabel;
@synthesize bookmarkCommentLabel;
@synthesize height;


#pragma mark - initializer
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.height = kJBBookmarkCatalogTableViewCellHeight;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
}


#pragma mark - api
- (void)designWithBookmark:(JBBookmark *)bookmark
{
    // タイトル
    [self.bookmarkTitleLabel setText:bookmark.title];

    // タグ
    NSMutableString *tagString = [NSMutableString stringWithCapacity:0];
    NSArray *tags = [bookmark tags];
    for (NSInteger i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        [tagString appendString:[NSString stringWithFormat:(i == 0) ? @"%@" : @" %@", tag]];
    }
    [self.bookmarkTagsLabel setText:tagString];
        // タグ位置調整
    [self designBookmarkTagsLabelPosition];

    // 日付
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    [self.bookmarkDateLabel setText:[dateFormatter stringFromDate:bookmark.issued]];
        // 日付位置調整
    [self.bookmarkDateLabel setFrame:CGRectMake(
        self.bookmarkTagsLabel.frame.origin.x+self.bookmarkTagsLabel.frame.size.width, self.bookmarkDateLabel.frame.origin.y,
        self.bookmarkDateLabel.frame.size.width, self.bookmarkDateLabel.frame.size.height
    )];

    // コメント
    [self.bookmarkCommentLabel setText:bookmark.summary];

    // 高さを調整
    if ([bookmark.summary isEqualToString:@""]) {
        self.height = kJBBookmarkCatalogTableViewCellLabelHeight - kJBBookmarkCatalogTableViewCellHeight;
        [self setFrame:CGRectMake(
            self.frame.origin.x, self.frame.origin.y,
            self.frame.size.width, self.height
        )];
    }
}


#pragma mark - private api
/**
 * タグラベルの位置を設定
 */
- (void)designBookmarkTagsLabelPosition
{
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : self.bookmarkTagsLabel.textColor,
        NSFontAttributeName : self.bookmarkTagsLabel.font,
    };
    NSAttributedString *tagText = [[NSAttributedString alloc] initWithString:self.bookmarkTagsLabel.text
                                                                  attributes:attributes];
    CGRect rect = [tagText boundingRectWithSize:CGSizeMake(
        kJBBookmarkCatalogTableViewCellDateLabelPositionXOfRightEdge - self.bookmarkTagsLabel.frame.origin.x,
        self.bookmarkTagsLabel.frame.size.height
    )
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    CGFloat rightEdgePointXOfBookmarkTagsLabel = self.bookmarkTagsLabel.frame.origin.x + self.bookmarkTagsLabel.frame.size.width;
    if (rightEdgePointXOfBookmarkTagsLabel > kJBBookmarkCatalogTableViewCellDateLabelPositionXOfRightEdge) {
        [self.bookmarkTagsLabel setFrame:CGRectMake(
            self.bookmarkTagsLabel.frame.origin.x, self.bookmarkTagsLabel.frame.origin.y,
            kJBBookmarkCatalogTableViewCellDateLabelPositionXOfRightEdge-self.bookmarkTagsLabel.frame.origin.x, self.bookmarkTagsLabel.frame.size.height
        )];
    }
    else {
        [self.bookmarkTagsLabel setFrame:CGRectMake(
            self.bookmarkTagsLabel.frame.origin.x, self.bookmarkTagsLabel.frame.origin.y,
            rect.size.width, self.bookmarkTagsLabel.frame.size.height
        )];
    }
}


@end
