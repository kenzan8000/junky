#import <CoreData/NSManagedObject.h>


#pragma mark - JBBookmark
/// ブックマーク
@interface JBBookmark : NSManagedObject {
}


#pragma mark - property
/// author
@property (nonatomic, strong) NSString *author;
/// dc:subject
@property (nonatomic, strong) NSString *dcSubject;
/// id
@property (nonatomic, strong) NSString *entryId;
/// issued
@property (nonatomic, strong) NSDate *issued;
/// link
@property (nonatomic, strong) NSString *link;
/// summary
@property (nonatomic, strong) NSString *summary;
/// title
@property (nonatomic, strong) NSString *title;


#pragma mark - api
/**
 * JSONからパラメーターをセット
 * @param JSON JSON
 *
 *
 * JSON example
 *
 * {
 *             author =             {
 *                 name = kenzan8000;
 *             };
 *             "dc:subject" = reading;
 *             id = "tag:hatena.ne.jp,2005:bookmark-kenzan8000-182160078";
 *             issued = "2014-02-13T18:09:12+09:00";
 *             link =             (
 *                                 {
 *                     "_href" = "http://cpplover.blogspot.com/2014/02/blog-post_13.html";
 *                     "_rel" = related;
 *                     "_type" = "text/html";
 *                 },
 *                                 {
 *                     "_href" = "http://b.hatena.ne.jp/kenzan8000/20140213#bookmark-182160078";
 *                     "_rel" = alternate;
 *                     "_type" = "text/html";
 *                 },
 *                                 {
 *                     "_href" = "http://b.hatena.ne.jp/atom/edit/182160078";
 *                     "_rel" = "service.edit";
 *                     "_title" = "\U672c\U306e\U866b: \U30c9\U30ef\U30f3\U30b4\U306b\U5165\U793e\U3057\U305f";
 *                     "_type" = "application/x.atom+xml";
 *                 }
 *             );
 *             summary = "\U81ea\U4e3b\U6027\U304c\U6d3b\U304b\U305b\U308b\U4eba\U6570\U4e0a\U9650";
 *             title = "\U672c\U306e\U866b: \U30c9\U30ef\U30f3\U30b4\U306b\U5165\U793e\U3057\U305f";
 * },
 */
- (void)setParametersWithJSON:(NSDictionary *)JSON;

/**
 * dc:subjectをtagのNSArrayにして返す
 * @return NSArray
 */
- (NSArray *)tags;

/**
 * ブックマークしたURL
 * @return NSURL
 */
- (NSURL *)URL;


@end

