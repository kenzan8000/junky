#import "JBModelList.h"
/// Pods
#import "NLCoreData.h"


#pragma mark - JBModelList
@implementation JBModelList


#pragma mark - property
@synthesize list;
@synthesize updateQueue;


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray arrayWithArray:@[]];

        NSString *queueName = [NSString stringWithFormat:@"%@.%@",
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
            NSStringFromClass([self class])
        ];
        self.updateQueue = dispatch_queue_create([queueName cStringUsingEncoding:[NSString defaultCStringEncoding]], NULL);
        [[NLCoreData shared] setModelName:kXCDataModelName];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [self removeManagedContextObserver];
    self.updateQueue = nil;
    self.list = nil;
}


#pragma mark - notification
- (void)updateMainContextWithNotification:(NSNotification *)notification
{
    [[self storeContext] mergeChangesFromContextDidSaveNotification:notification];
}

- (void)mergeChangesWithNotification:(NSNotification *)notification
{
    if (notification.object != [self storeContext]) {
        [self removeManagedContextObserver];
        [self performSelectorOnMainThread:@selector(updateMainContextWithNotification:)
                               withObject:notification
                            waitUntilDone:NO];
    }
}


#pragma mark - api
- (NSManagedObjectContext *)storeContext
{
    return [NSManagedObjectContext storeContext];
}

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread
{
    NSMutableDictionary *threadDictionary = [thread threadDictionary];
    NSString *threadKey = [NSString stringWithFormat:@"%@.%@",
        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
        NSStringFromClass([self class])
    ];
    NSManagedObjectContext *context = [threadDictionary objectForKey:threadKey];

    if (!context) {
        if ([[NSThread currentThread] isMainThread]) {
            context = [self storeContext];
        }
        else {
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [context setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
        }
        [threadDictionary setObject:context
                             forKey:threadKey];
    }

    return context;
}

- (void)addManagedContextObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChangesWithNotification:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (void)removeManagedContextObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)count
{
    return [self.list count];
}

- (id)modelWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
}


@end
