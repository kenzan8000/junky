#import "JBRSSDiscover.h"


#pragma mark - JBRSSDiscover
@implementation JBRSSDiscover


#pragma mark - synthesize
@synthesize feedlink;
@synthesize link;
@synthesize subscribeId;
@synthesize subscribersCount;
@synthesize title;


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
            [allKeys containsObject:@"subscribe_id"] == NO ||
            [allKeys containsObject:@"subscribers_count"] == NO ||
            [allKeys containsObject:@"title"] == NO) { continue; }

        JBRSSDiscover *discover = [JBRSSDiscover new];
        discover.feedlink = [NSURL URLWithString:discoverJSON[@"feedlink"]];
        discover.link = [NSURL URLWithString:discoverJSON[@"link"]];
        discover.subscribeId = [NSString stringWithFormat:@"%@", discoverJSON[@"subscribe_id"]];
        discover.subscribersCount = [discoverJSON[@"subscribers_count"] integerValue];
        discover.title = [NSString stringWithFormat:@"%@", discoverJSON[@"title"]];
        [list addObject:discover];
    }
    return list;
}


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
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
