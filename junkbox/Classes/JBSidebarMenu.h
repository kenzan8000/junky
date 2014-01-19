// Pods
#import "RNFrostedSidebar.h"


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


#pragma mark - initializer
/**
 * constructor
 * @param type JBSidebarMenuType
 * @return id
 */
- (id)initWithSidebarType:(JBSidebarMenuType)type;


#pragma mark - api
/**
 * 表示
 */
- (void)show;


@end
