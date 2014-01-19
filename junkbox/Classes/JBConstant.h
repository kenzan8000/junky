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
