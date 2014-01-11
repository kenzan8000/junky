#import "JBRSSFeedUnreadLists.h"
#import "JBRSSFeedSubsUnreadList.h"
#import "JBRSSFeedSubsUnread.h"


#pragma mark - JBRSSFeedUnreadLists
@implementation JBRSSFeedUnreadLists


#pragma mark - synthesize
@synthesize list;


#pragma mark - initializer
- (id)initWithSubsUnreadList:(JBRSSFeedSubsUnreadList *)subsUnreadList
               listsDelegate:(id<JBRSSFeedUnreadListsDelegate>)listsDelegate
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray arrayWithArray:@[]];

        NSInteger count = [subsUnreadList count];
        for (NSInteger i = 0; i < count; i++) {
            JBRSSFeedSubsUnread *subsUnread = [subsUnreadList unreadWithIndex:i];
            NSString *subscribeId = [subsUnread subscribeId];
            JBRSSFeedUnreadList *unreadList = [[JBRSSFeedUnreadList alloc] initWithSubscribeId:subscribeId
                                                                                  listDelegate:nil
                                                                                 listsDelegate:listsDelegate];
            [self.list addObject:unreadList];
        }
    }
    return self;
}


#pragma mark - dealloc
- (void)dealloc
{
    self.list = nil;
}


#pragma mark - api
- (void)loadWithIndex:(NSInteger)index
{
    if ([self isOutOfIndex:index]) { return; }
    [(JBRSSFeedUnreadList *)(self.list[index]) loadFeedFromWebAPI];
}

- (void)stopLoadingWithIndex:(NSInteger)index
{
    if ([self isOutOfIndex:index]) { return; }
    [(JBRSSFeedUnreadList *)(self.list[index]) stopLoadingFeedFromWebAPI];
}

- (void)loadWithUnreadList:(JBRSSFeedUnreadList *)unreadList
{
}

- (void)stopLoadWithUnreadList:(JBRSSFeedUnreadList *)unreadList
{
}

- (void)stopAllLoading
{
    for (JBRSSFeedUnreadList *unreadList in self.list) {
        [unreadList stopLoadingFeedFromWebAPI];
    }
}

- (JBRSSFeedUnreadList *)listWithIndex:(NSInteger)index
{
    if ([self isOutOfIndex:index]) { return nil; }
    return self.list[index];
}

- (NSInteger)indexWithList:(JBRSSFeedUnreadList *)unreadList
{
    for (NSInteger index = 0; index < self.list.count; index++) {
        if (self.list[index] == unreadList) { return index; }
    }
    return -1;
}

- (NSInteger)count
{
    return self.list.count;
}


#pragma mark - private api
/**
 * listのindex範囲外か
 * @return BOOL
 */
- (BOOL)isOutOfIndex:(NSInteger)index
{
    return (index < 0 || index >= [self.list count]);
}


@end
