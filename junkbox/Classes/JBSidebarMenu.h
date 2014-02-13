// Pods
#import "RNFrostedSidebar.h"



#pragma mark - class
@class JBSidebarMenu;


#pragma mark - JBSidebarMenuDelegate
/// JBSidebarMenuDelegate
@protocol JBSidebarMenuDelegate <NSObject>


/**
 * Bookmarkの編集画面へ遷移
 * @param sidebarMenu JBSidebarMenu
 * @param URL BookmarkするページのURL
 */
- (void)bookmarkWillStartWithSidebarMenu:(JBSidebarMenu *)sidebarMenu
                                     URL:(NSURL *)URL;


@end


#pragma mark - constant
/// Sidebarの種類
typedef NS_ENUM(NSInteger, JBSidebarMenuType) {
    JBSidebarMenuTypeDefault,
};


#pragma mark - JBSidebarMenu
/// サイドバーメニュー
@interface JBSidebarMenu : NSObject <RNFrostedSidebarDelegate> {
}


#pragma mark - property
/// sidebar
@property (nonatomic, strong) RNFrostedSidebar *sidebar;
/// sidebarの種類
@property (nonatomic, assign) JBSidebarMenuType type;
/// LivedoorReader PINに追加する、Safari or Chrome で開く用URL
@property (nonatomic, strong) NSURL *webURL;
/// LivedoorReader PINに追加する、Safari or Chrome で開く用ページタイトル
@property (nonatomic, strong) NSString *webTitle;

/// Delegate
@property (nonatomic, weak) id<JBSidebarMenuDelegate> delegate;


#pragma mark - initializer
/**
 * constructor
 * @param type JBSidebarMenuType
 * @return id
 */
- (id)initWithSidebarType:(JBSidebarMenuType)t;


#pragma mark - api
/**
 * 表示
 */
- (void)show;


@end
