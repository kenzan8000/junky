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
@implementation JBRSSPinList


#pragma mark - property
@synthesize delegate;


#pragma mark - class meethod
+ (JBRSSPinList *)sharedInstance
{
    static dispatch_once_t onceToken = NULL;
    static JBRSSPinList *_JBRSSPinList = nil;
    dispatch_once(&onceToken, ^ () {
        _JBRSSPinList = [JBRSSPinList new];
    });
    return _JBRSSPinList;
}


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


#pragma mark - api
- (NSManagedObjectContext *)storeContext
{
    static dispatch_once_t onceToken = NULL;
    static NSManagedObjectContext *_JBRSSPinListManagedObjectContext = nil;

    dispatch_once(&onceToken, ^ () {
        //_JBRSSPinListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _JBRSSPinListManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_JBRSSPinListManagedObjectContext setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
    });

    return _JBRSSPinListManagedObjectContext;
}

- (JBRSSPin *)pinWithIndex:(NSInteger)index
{
    return [super modelWithIndex:index];
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
        NSManagedObjectContext *context = [weakSelf managedObjectContextForThread:[NSThread currentThread]];
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:
            [JBRSSPin fetchWithRequest:^ (NSFetchRequest *request) {
                [request setPredicate:nil];
                [request setReturnsObjectsAsFaults:NO];
            }
                               context:context]
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
    [self addPinToLocalWithTitle:title
                            link:link];
    [self addPinToWebAPIWithTitle:title
                             link:link];
}

- (void)removePinWithLink:(NSString *)link
{
    [self removePinToLocalWithLink:link];
    [self removePinToWebAPIWithLink:link];
}


#pragma makr - private api
/**
 * 同じPINがあるかどうか
 * @param link link
 * @return BOOL
 */
- (BOOL)hasPinWithLink:(NSString *)link
{
    for (JBRSSPin *pin in self.list) {
        if ([pin.link isEqualToString:link]) { return YES; }
    }
    return NO;
}

/**
 * listのindexのPINを削除
 * @param index index
 * @return 削除したPIN
 */
- (JBRSSPin *)removePinWithIndex:(NSInteger)index
{
    JBRSSPin *pin = nil;
    if (index >= 0 && index < self.list.count) {
        pin = self.list[index];
        [self.list removeObjectAtIndex:index];
    }
    return pin;
}

/**
 * 同じlinkを持つPINのindexを返す
 * @param link link
 * @return NSInteger
 */
- (NSInteger)indexWithLink:(NSString *)link
{
    for (NSInteger i = 0; i < self.list.count; i++) {
        JBRSSPin *pin = self.list[i];
        if ([pin.link isEqualToString:link]) { return i; }
    }
    return -1;
}

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
        NSManagedObjectContext *context = [weakSelf managedObjectContextForThread:[NSThread currentThread]];
        [JBRSSPin deleteWithRequest:^ (NSFetchRequest *request) {
            [request setPredicate:nil];
            [request setReturnsObjectsAsFaults:NO];
        }
                            context:context];
        NSMutableArray *temporaryArray = [NSMutableArray arrayWithArray:@[]];
        for (NSDictionary *dict in JSON) {
            JBRSSPin *pin = [JBRSSPin insertInContext:context];
            pin.title = [NSString stringWithFormat:@"%@", dict[@"title"]];
            pin.link = [NSString stringWithFormat:@"%@", dict[@"link"]];
            pin.createdOn = [NSString stringWithFormat:@"%@", dict[@"created_on"]];

            [temporaryArray addObject:pin];
        }
        [weakSelf addManagedContextObserver];
        [context save];

        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            weakSelf.list = temporaryArray;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pinDidFinishLoadWithList:)]) {
                [weakSelf.delegate pinDidFinishLoadWithList:weakSelf];
            }
        });
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
    // 既にPINに追加されている
    if ([self hasPinWithLink:link]) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(weakSelf.updateQueue, ^ () {
        NSManagedObjectContext *context = [weakSelf managedObjectContextForThread:[NSThread currentThread]];
        JBRSSPin *pin = [JBRSSPin insertInContext:context];
        pin.title = title;
        pin.link = link;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        pin.createdOn = [dateFormatter stringFromDate:[NSDate date]];
        [weakSelf addManagedContextObserver];
        [context save];

        // delegate
        dispatch_async(dispatch_get_main_queue(), ^ () {
            [weakSelf.list insertObject:pin
                                atIndex:0];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pinDidFinishLoadWithList:)]) {
                [weakSelf.delegate pinDidFinishLoadWithList:weakSelf];
            }
        });
    });
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
    // PINになかった
    if ([self hasPinWithLink:link] == NO) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ () {
        // delegate
        NSInteger index = [self indexWithLink:link];
        JBRSSPin *pin = [weakSelf removePinWithIndex:index];
        if (pin &&
            weakSelf.delegate &&
            [weakSelf.delegate respondsToSelector:@selector(pinDidDeleteWithList:link:index:)]) {
            [weakSelf.delegate pinDidDeleteWithList:weakSelf
                                               link:link
                                              index:index];
        }

        // delete
        dispatch_async(weakSelf.updateQueue, ^ () {
            NSManagedObjectContext *context = [weakSelf managedObjectContextForThread:[NSThread currentThread]];
            [JBRSSPin deleteWithRequest:^ (NSFetchRequest *request) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link = %@", link];
                [request setPredicate:predicate];
                [request setReturnsObjectsAsFaults:NO];
            }
                            context:context];
            [weakSelf addManagedContextObserver];
            [context save];
        });
    });
}


@end
