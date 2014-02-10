#pragma mark - UIViewController+ModalAnimatedTransition
/// Modal Animation拡張
@interface UIViewController (ModalAnimatedTransition) {
}


#pragma mark - api
/**
 * present modal
 * @param viewController modalするViewController
 * @param animated アニメーションするかどうか
 * @param completion modal完了後処理
 */
- (void)presentViewController:(UIViewController *)viewController
                   JBAnimated:(BOOL)animated
                   completion:(void (^)(void))completion;

/**
 * dismiss modal
 * @param animated アニメーションするかどうか
 * @param completion modal完了後処理
 */
- (void)dismissViewControllerJBAnimated:(BOOL)animated
                             completion:(void (^)(void))completion;


@end

