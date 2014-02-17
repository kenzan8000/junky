#import "JBRSSDiscover.h"


#pragma mark - JBRSSDiscover
@implementation JBRSSDiscover


#pragma mark - synthesize
@synthesize feedlink;
@synthesize link;
@synthesize subscribeId;
@synthesize subscribersCount;
@synthesize title;
@synthesize rating;
@synthesize isSubscribing;


#pragma mark - class method
+ (NSMutableArray *)JBRSSDiscoverListWithJSON:(NSArray *)JSON
{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[]];
    if (JSON == nil) { return list; }
    if ([JSON isKindOfClass:[NSArray class]] == NO) { return list; }

    for (NSDictionary *discoverJSON in JSON) {
        NSArray *allKeys = [discoverJSON allKeys];
        if ([allKeys containsObject:@"feedlink"] == NO ||
            [allKeys containsObject:@"link"] == NO ||
            [allKeys containsObject:@"subscribers_count"] == NO ||
            [allKeys containsObject:@"title"] == NO) { continue; }

        JBRSSDiscover *discover = [JBRSSDiscover new];
        discover.feedlink = [NSURL URLWithString:discoverJSON[@"feedlink"]];
        discover.link = [NSURL URLWithString:discoverJSON[@"link"]];
        if ([allKeys containsObject:@"subscribe_id"]) {
            discover.subscribeId = [NSString stringWithFormat:@"%@", discoverJSON[@"subscribe_id"]];
        }
        discover.subscribersCount = [discoverJSON[@"subscribers_count"] integerValue];
        discover.title = [NSString stringWithFormat:@"%@", discoverJSON[@"title"]];
        discover.rating = 0;
        discover.isSubscribing = NO;
        [list addObject:discover];
    }
    return list;
}


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.subscribeId = @"";
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    self.feedlink = nil;
    self.link = nil;
    self.subscribeId = nil;
    self.title = nil;
}


@end
