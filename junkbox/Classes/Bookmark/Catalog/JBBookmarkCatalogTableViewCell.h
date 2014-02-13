#pragma mark - class
@class JBBookmark;


#pragma mark - constant
/// Defaultの高さ
#define kJBBookmarkCatalogTableViewCellHeight 84
/// Label1行の高さ
#define kJBBookmarkCatalogTableViewCellLabelHeight 15
/// タグラベルのx座標位置リミット
#define kJBBookmarkCatalogTableViewCellDateLabelPositionXOfRightEdge 226


#pragma mark - JBBookmarkCatalogTableViewCell
/// ブックマーク一覧
@interface JBBookmarkCatalogTableViewCell : UITableViewCell {
}


#pragma mark - property
/// タイトル
@property (nonatomic, weak) IBOutlet UILabel *bookmarkTitleLabel;
/// タグ
@property (nonatomic, weak) IBOutlet UILabel *bookmarkTagsLabel;
/// 日付
@property (nonatomic, weak) IBOutlet UILabel *bookmarkDateLabel;
/// コメント
@property (nonatomic, weak) IBOutlet UILabel *bookmarkCommentLabel;

/// cellの高さ
@property (nonatomic, assign) CGFloat height;


#pragma mark - class method
/**
 * コメントから高さを算出
 * @param bookmarkComment bookmarkComment
 * @return height
 */
+ (CGFloat)cellHeightWithBookmarkComment:(NSString *)bookmarkComment;

#pragma mark - api
/**
 * 見た目を調整
 * @param bookmark bookmarkのデータ
 */
- (void)designWithBookmark:(JBBookmark *)bookmark;


@end
