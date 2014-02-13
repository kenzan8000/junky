#import "JBBookmarkCatalogTableViewCell.h"
#import "JBBookmark.h"


#pragma mark - JBBookmarkCatalogTableViewCell
@implementation JBBookmarkCatalogTableViewCell


#pragma mark - synthesize
@synthesize bookmarkTitleLabel;
@synthesize bookmarkTagsLabel;
@synthesize bookmarkDateLabel;
@synthesize bookmarkCommentLabel;


#pragma mark - class method
+ (CGFloat)cellHeightWithBookmarkComment:(NSString *)bookmarkComment
{
    if ([bookmarkComment isEqualToString:@""]) {
        return kJBBookmarkCatalogTableViewCellLabelHeight - kJBBookmarkCatalogTableViewCellHeight;
    }
    return kJBBookmarkCatalogTableViewCellLabelHeight;
/*
    if (bookmarkComment == nil || [bookmarkComment isEqualToString:@""]) {
        return kJBBookmarkCatalogTableViewCellLabelHeight - kJBBookmarkCatalogTableViewCellHeight;
    }

    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12.0f],
    };
    NSAttributedString *bookmarkText = [[NSAttributedString alloc] initWithString:bookmarkComment
                                                                       attributes:attributes];
    CGRect rect = [bookmarkText boundingRectWithSize:CGSizeMake(276, 100)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];

    return (rect.size.height > kJBBookmarkCatalogTableViewCellLabelHeight) ?
        kJBBookmarkCatalogTableViewCellHeight + kJBBookmarkCatalogTableViewCellLabelHeight :
        kJBBookmarkCatalogTableViewCellHeight;
*/
}


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
    CGFloat height = [JBBookmarkCatalogTableViewCell cellHeightWithBookmarkComment:bookmark.summary];
    if (height < kJBBookmarkCatalogTableViewCellHeight) {
        [self setFrame:CGRectMake(
            self.frame.origin.x, self.frame.origin.y,
            self.frame.size.width, height
        )];
    }
/*
    CGFloat height = [JBBookmarkCatalogTableViewCell cellHeightWithBookmarkComment:bookmark.summary];
    [self setFrame:CGRectMake(
        self.frame.origin.x, self.frame.origin.y,
        self.frame.size.width, height
    )];
    if (height > kJBBookmarkCatalogTableViewCellHeight) {
        [self.bookmarkCommentLabel setNumberOfLines:2];
        [self.bookmarkCommentLabel setFrame:CGRectMake(
            self.bookmarkCommentLabel.frame.origin.x, self.bookmarkCommentLabel.frame.origin.y,
            self.bookmarkCommentLabel.frame.size.width, self.bookmarkCommentLabel.frame.size.height + kJBBookmarkCatalogTableViewCellLabelHeight
        )];
    }
*/
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
        CGFloat offset = 4.0f;
        [self.bookmarkTagsLabel setFrame:CGRectMake(
            self.bookmarkTagsLabel.frame.origin.x, self.bookmarkTagsLabel.frame.origin.y,
            rect.size.width + offset, self.bookmarkTagsLabel.frame.size.height
        )];
    }
}


@end
