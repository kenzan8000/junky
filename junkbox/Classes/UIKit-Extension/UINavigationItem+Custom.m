#import "UINavigationItem+Custom.h"
// UIKit-Extension
//#import "UIButton+Custom.h"
//#import "UIColor+Hexadecimal.h"


#pragma mark - implementation
@implementation UINavigationItem (Custom)


//#pragma mark - api
//- (void)designDefaultNavigationItemWithLeftTarget:(id)leftTarget
//                                     leftSelector:(SEL)leftSelector
//                                      rightTarget:(id)rightTarget
//                                    rightSelector:(SEL)rightSelector
//{
//    [self resetBarButtonItems];
//
//    NSDictionary *leftButtons = @{
//        @"UIControlStateNormal":     [UIImage imageNamed:kImageDefaultWhiteButton],
//        @"UIControlStateHighlighted":[UIImage imageNamed:kImageDefaultWhiteButtonTouched],
//        @"UIControlStateDisabled":   [UIImage imageNamed:kImageDefaultWhiteButton],
//        @"UIControlStateSelected":   [UIImage imageNamed:kImageDefaultWhiteButtonTouched],
//        @"title":@"Ξ メニュー",
//    };
//    NSDictionary *rightButtons = @{
//        @"UIControlStateNormal":     [UIImage imageNamed:kImageDefaultWhiteButton],
//        @"UIControlStateHighlighted":[UIImage imageNamed:kImageDefaultWhiteButtonTouched],
//        @"UIControlStateDisabled":   [UIImage imageNamed:kImageDefaultWhiteButton],
//        @"UIControlStateSelected":   [UIImage imageNamed:kImageDefaultWhiteButtonTouched],
//        @"title":@"⌘ お知らせ",
//    };
//
//    [self setBarButtonItemWithLeftButtons:leftButtons
//                               leftTarget:leftTarget
//                             leftSelector:leftSelector
//                             rightButtons:rightButtons
//                              rightTarget:rightTarget
//                            rightSelector:rightSelector];
//}
//
//- (void)designPushedNavigationItemWithLeftTarget:(id)leftTarget
//                                    leftSelector:(SEL)leftSelector
//                                     rightTarget:(id)rightTarget
//                                   rightSelector:(SEL)rightSelector
//{
//    [self resetBarButtonItems];
//
//    NSDictionary *leftButtons = @{
//        @"UIControlStateNormal":     [UIImage imageNamed:kImageBackWhiteButton],
//        @"UIControlStateHighlighted":[UIImage imageNamed:kImageBackWhiteButtonTouched],
//        @"UIControlStateDisabled":   [UIImage imageNamed:kImageBackWhiteButtonTouched],
//        @"UIControlStateSelected":   [UIImage imageNamed:kImageBackWhiteButton],
//        @"title":@"　戻る",
//    };
//
//    [self setBarButtonItemWithLeftButtons:leftButtons
//                               leftTarget:leftTarget
//                             leftSelector:leftSelector
//                             rightButtons:nil
//                              rightTarget:NULL
//                            rightSelector:NULL];
//}
//
//- (void)resetBarButtonItems
//{
//    NSMutableArray *items = [NSMutableArray array];
//    if (self.leftBarButtonItem) { [items addObject:self.leftBarButtonItem]; }
//    if (self.rightBarButtonItem) { [items addObject:self.rightBarButtonItem]; }
//
//    for (UIBarButtonItem *item in items) {
//        if (item.customView && [[item.customView class] isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *)item.customView;
//            [btn setBackgroundImage:nil forState:UIControlStateNormal];
//            [btn setBackgroundImage:nil forState:UIControlStateHighlighted];
//            [btn setBackgroundImage:nil forState:UIControlStateDisabled];
//            [btn setBackgroundImage:nil forState:UIControlStateSelected];
//            [btn setTitle:nil forState:UIControlStateNormal];
//            [[btn titleLabel] setFont:nil];
//            [[btn titleLabel] setTextColor:nil];
//        }
//    }
//
//    if (self.leftBarButtonItem) {
//        self.leftBarButtonItem = nil;
//    }
//    if (self.rightBarButtonItem) {
//        self.rightBarButtonItem = nil;
//    }
//}
//
//
//#pragma mark - private api
///**
// * BarButtonItemを生成
// * @param buttons object:ボタン画像 key:UIControlStateのNSString
// * @param target
// * @param selector
// */
//+ (UIBarButtonItem *)barButtonItemWithButtons:(NSDictionary *)buttons
//                                       target:(id)target
//                                     selector:(SEL)selector
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    // 画像
//    UIImage *image = nil;
//    if ([[buttons allKeys] containsObject:@"UIControlStateNormal"]) {
//        image = buttons[@"UIControlStateNormal"];
//        [btn setBackgroundImage:buttons[@"UIControlStateNormal"] forState:UIControlStateNormal];
//    }
//    if ([[buttons allKeys] containsObject:@"UIControlStateHighlighted"]) {
//        [btn setBackgroundImage:buttons[@"UIControlStateHighlighted"] forState:UIControlStateHighlighted];
//    }
//    if ([[buttons allKeys] containsObject:@"UIControlStateDisabled"]) {
//        [btn setBackgroundImage:buttons[@"UIControlStateDisabled"] forState:UIControlStateDisabled];
//    }
//    if ([[buttons allKeys] containsObject:@"UIControlStateSelected"]) {
//        [btn setBackgroundImage:buttons[@"UIControlStateSelected"] forState:UIControlStateSelected];
//    }
//
//    // サイズ・位置
//    if (image) {
//        CGFloat offset = (kNavigationBarDefaultHeight - image.size.height/2);
//        [btn setFrame:CGRectMake(offset/2, 0, image.size.width/2, kNavigationBarDefaultHeight-offset)];
//    }
//
//    // タイトル
//    if ([[buttons allKeys] containsObject:@"title"]) {
//        [btn setTitle:buttons[@"title"] forState:UIControlStateNormal];
//        [[btn titleLabel] setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:11]];
//
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
//        [btn setTitleColor:[UIColor colorWithHexadecimal:0xccccccff]
//          titleShadowColor:[UIColor colorWithHexadecimal:0x888888ff]];
//        [[btn titleLabel] setShadowOffset:CGSizeMake(0, -1)];
//    }
//
//    // タッチイベントリスナー
//    if (target != nil && selector != nil) {
//        [btn addTarget:target
//                action:selector
//      forControlEvents:UIControlEventTouchUpInside];
///*
//        [btn addTarget:target
//                action:@selector(touchedDownInsideWithButton:)
//      forControlEvents:UIControlEventTouchDown];
//*/
//    }
//
//    return [[UIBarButtonItem alloc] initWithCustomView:btn];
//}
//
///**
// * BarButtonItemを生成
// * @param leftButtons object:ボタン画像orボタンのタイトル key:
// * @param leftTarget
// * @param leftSelector
// * @param rightButtons object:ボタン画像orボタンのタイトル key:
// * @param rightTarget
// * @param rightSelector
// */
//- (void)setBarButtonItemWithLeftButtons:(NSDictionary *)leftButtons
//                             leftTarget:(id)leftTarget
//                           leftSelector:(SEL)leftSelector
//                           rightButtons:(NSDictionary *)rightButtons
//                            rightTarget:(id)rightTarget
//                          rightSelector:(SEL)rightSelector
//{
//    if (leftButtons) {
//        self.leftBarButtonItem = [UINavigationItem barButtonItemWithButtons:leftButtons
//                                                                     target:leftTarget
//                                                                   selector:leftSelector];
//    }
//    if (rightButtons) {
//        self.rightBarButtonItem = [UINavigationItem barButtonItemWithButtons:rightButtons
//                                                                      target:rightTarget
//                                                                    selector:rightSelector];
//    }
//}


@end
