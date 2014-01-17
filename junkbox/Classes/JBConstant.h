#pragma mark - constant


#pragma mark - Storyboard
/// ルート
#define kStoryboardMainStoryboard                   @"MainStoryboard"
/// RSSログイン遷移
#define kStoryboardRSSLogin                         @"JBRSSLogin"
/// RSSフィード遷移
#define kStoryboardRSSFeed                          @"JBRSSFeed"
/// ブックマーク遷移
#define kStoryboardBookmark                         @"JBBookmark"

/// segue identifier
#define kStoryboardSeguePushRSSFeedUnreadController @"pushJBRSSFeedUnreadController"
#define kStoryboardSeguePushWebViewController       @"pushJBWebViewController"


#pragma mark - UI
#define kDefaultNavigationItemFrame { {0, 0,}, {64, 44}, }


#pragma mark - Notification
/// RSS Reader ログイン開始
#define kNotificationRSSLoginStart                  @"JBNotificationRSSLoginStart"
/// RSS Reader ログイン成功
#define kNotificationRSSLoginSuccess                @"JBNotificationRSSLoginSuccess"
/// RSS Reader ログイン失敗
#define kNotificationRSSLoginFailure                @"JBNotificationRSSLoginFailure"
/// RSS Reader セッション無効
#define kNotificationRSSLoginInvalid                @"JBNotificationRSSLoginInvalid"
/// WebView読み込み完了
#define kNotificationWebViewProgressDidFinished     @"JBNotificationWebViewProgressDidFinished"

