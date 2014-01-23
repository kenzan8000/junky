#import "JBRSSPinList.h"
#import "JBRSSPin.h"
#import "JBRSSOperationQueue.h"
#import "JBRSSPinAllOperation.h"
#import "JBRSSPinAddOperation.h"
#import "JBRSSPinRemoveOperation.h"
/// Connection
#import "StatusCode.h"
/// NSFoundation-Extension
#import "NSData+JSON.h"
#import "NSURLRequest+JBRSS.h"
/// Pods
#import "NLCoreData.h"


#pragma mark - JBRSSPinList
@interface JBRSSPinList ()


/// 一覧の更新処理のためのQueue
@property (nonatomic, assign) dispatch_queue_t updateQueue;


@end


#pragma mark - JBRSSPinList
@implementation JBRSSPinList


#pragma mark - property
@synthesize delegate;
@synthesize list;
@synthesize updateQueue;


#pragma mark - class meethod
+ (JBRSSPinList *)sharedInstance
{
    static dispatch_once_t onceToken = NULL;
    static JBRSSPinList *_JBRSSPinList = nil;
    dispatch_once(&onceToken, ^ () {
        _JBRSSPinList = [[JBRSSPinList alloc] init];
    });
    return _JBRSSPinList;
}


/**
 * 一覧更新処理用のmanagedObjectContext
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContext
{
    static dispatch_once_t onceToken = NULL;
    static NSManagedObjectContext *_JBRSSPinListManagedObjectContext = nil;

    dispatch_once(&onceToken, ^ () {
        _JBRSSPinListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_JBRSSPinListManagedObjectContext setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
    });

    return _JBRSSPinListManagedObjectContext;
}


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray arrayWithArray:@[]];

        NSString *queueName = [NSString stringWithFormat:@"%@.%@",
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
            NSStringFromClass([JBRSSPinList class])
        ];
        self.updateQueue = dispatch_queue_create([queueName cStringUsingEncoding:[NSString defaultCStringEncoding]], NULL);
        [[NLCoreData shared] setModelName:kXCDataModelName];
    }
    return self;
}

- (id)initWithDelegate:(id<JBRSSPinListDelegate>)del
{
    self = [self init];
    if (self) {
        self.delegate = del;
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    dispatch_release(self.updateQueue);
    self.list = nil;
}


#pragma mark - api
- (NSInteger)count
{
    return [self.list count];
}

- (JBRSSPin *)pinWithIndex:(NSInteger)index
{
    if (index < 0 || index >= [self count]) { return nil; }
    return self.list[index];
}

- (void)loadAllPinFromWebAPI
{
    __weak __typeof(self) weakSelf = self;
    // 未読フィード一覧
    JBRSSPinAllOperation *operation = [[JBRSSPinAllOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error) {
        // 成功
        if (error == nil) {
            NSArray *JSON = [object JSON];
            JBLog(@"%@", JSON);
            [weakSelf finishLoadListWithJSON:JSON];

            return;
        }
        // 失敗
        [weakSelf failLoadListWithError:error];
    }];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

- (void)loadAllPinFromLocal
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(weakSelf.updateQueue, ^ () {
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:
            [JBRSSPin fetchWithRequest:^ (NSFetchRequest *request) {
                [request setPredicate:nil];
                [request setReturnsObjectsAsFaults:NO];
            }
                              context:[JBRSSPinList managedObjectContext]]
        ];
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pinDidFinishLoadWithList:)]) {
                [weakSelf.delegate pinDidFinishLoadWithList:weakSelf];
            }
        });
    });
}

- (void)addPinWithTitle:(NSString *)title
                   link:(NSString *)link
{
    [self addPinToWebAPIWithTitle:title
                             link:link];
    [self addPinToLocalWithTitle:title
                            link:link];
}

- (void)removePinWithLink:(NSString *)link
{
    [self removePinToWebAPIWithLink:link];
    [self removePinToLocalWithLink:link];
}


#pragma makr - private api
/**
 * 一覧ロード完了後処理
 * @param JSON JSON
 */
- (void)finishLoadListWithJSON:(NSArray *)JSON
{
    if (JSON == nil) { return; }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(weakSelf.updateQueue, ^ () {
        // create list and save
        NSManagedObjectContext *context = [JBRSSPinList managedObjectContext];
        [JBRSSPin deleteInContext:context
                        predicate:nil];
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:@[]];
        for (NSDictionary *dict in JSON) {
            JBRSSPin *pin = [JBRSSPin insertInContext:context];
            pin.title = [NSString stringWithFormat:@"%@", dict[@"title"]];
            pin.link = [NSString stringWithFormat:@"%@", dict[@"link"]];
            pin.createdOn = [NSString stringWithFormat:@"%@", dict[@"created_on"]];

            [temporaryArray addObject:pin];
        }
        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pinDidFinishLoadWithList:)]) {
                [weakSelf.delegate pinDidFinishLoadWithList:weakSelf];
            }
        });
        [context save];
    });
}

/**
 * 一覧の読み込み失敗処理
 * @param error error
 */
- (void)failLoadListWithError:(NSError *)error
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pinDidFailLoadWithError:)]) {
            [weakSelf.delegate pinDidFailLoadWithError:error];
        }
    });
}

/**
 * PIN追加(WebAPI)
 * @param title title
 * @param link link
 */
- (void)addPinToWebAPIWithTitle:(NSString *)title
                           link:(NSString *)link
{
    // Pin追加
    JBRSSPinAddOperation *operation = [[JBRSSPinAddOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error)
        {
            // 成功
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            if (error == nil && [[JSON allKeys] containsObject:@"isSuccess"] && [JSON[@"isSuccess"] boolValue]) {
                return;
            }
            // 失敗
        }
                                                                           pinTitle:title
                                                                            pinLink:link
    ];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

/**
 * PIN追加(Local)
 * @param title title
 * @param link link
 */
- (void)addPinToLocalWithTitle:(NSString *)title
                          link:(NSString *)link
{
}

/**
 * PIN削除(WebAPI)
 */
- (void)removePinToWebAPIWithLink:(NSString *)link
{
    JBRSSPinRemoveOperation *operation = [[JBRSSPinRemoveOperation alloc] initWithHandler:^ (NSHTTPURLResponse *response, id object, NSError *error)
        {
            // 成功
            NSDictionary *JSON = [object JSON];
            JBLog(@"%@", JSON);
            if (error == nil && [[JSON allKeys] containsObject:@"isSuccess"] && [JSON[@"isSuccess"] boolValue]) {
                return;
            }
            // 失敗
        }
                                                                            pinLink:link
    ];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [[JBRSSOperationQueue defaultQueue] addOperation:operation];
}

/**
 * PIN削除(Local)
 */
- (void)removePinToLocalWithLink:(NSString *)link
{
}


@end
