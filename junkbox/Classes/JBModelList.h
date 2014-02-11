#pragma mark - JBModelList
/// ModelのList
@interface JBModelList : NSObject {
}


#pragma mark - property
/// 一覧
@property (nonatomic, strong) NSMutableArray *list;


#pragma mark - api
/**
 * 一覧更新処理用のmainContext
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)mainContext;

/**
 * threadごとの更新処理用のcontext
 * @param thread thread
 * @return NSManagedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;

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
