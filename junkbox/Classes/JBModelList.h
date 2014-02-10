#pragma mark - JBModelList
/// ModelのList
@interface JBModelList : NSObject {
}


#pragma mark - property
/// 一覧
@property (nonatomic, strong) NSMutableArray *list;
/// 一覧の更新処理のためのQueue
@property (nonatomic, assign) dispatch_queue_t updateQueue;


#pragma mark - api
/**
 * 一覧更新処理用のstoreContext
 * @return NSManagedObjectContext
 */
- (NSManagedObjectContext *)storeContext;

/**
 * threadごとの更新処理用のcontext
 * @param thread currentThread
 * @return NSManagedObjectContext
 */
- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;

- (void)addManagedContextObserver;
- (void)removeManagedContextObserver;

/**
 * List数
 * @return count
 */
- (NSInteger)count;

/**
 * modelを取得
 * @param index index
 * @return model
 */
- (id)modelWithIndex:(NSInteger)index;


@end
