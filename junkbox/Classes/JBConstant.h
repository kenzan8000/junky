#pragma mark - constant


#pragma mark - Storyboard
/// App Store URL
#define kURLAppStore                                @"http://itunes.apple.com/us/app/junky/id"


#pragma mark - Storyboard
/// ルート
#define kStoryboardMainStoryboard                   @"MainStoryboard"
/// RSSログイン遷移
#define kStoryboardRSSLogin                         @"JBRSSLogin"
/// RSSフィード遷移
#define kStoryboardRSSFeed                          @"JBRSSFeed"
/// あとで読む遷移
#define kStoryboardRSSPin                           @"JBRSSPin"
/// ブックマーク遷移
#define kStoryboardBookmark                         @"JBBookmark"
/// 設定画面遷移
#define kStoryboardSetting                          @"JBSetting"

/// フィード詳細画面遷移
#define kStoryboardSeguePushRSSFeedUnreadController @"pushJBRSSFeedUnreadController"
/// ライセンス情報画面遷移
#define kStoryboardSeguePushLicenceController       @"pushJBLicenceViewCntroller"

#pragma mark - Notification
/// RSS Reader ログイン開始
#define kNotificationRSSLoginStart                              @"JBNotificationRSSLoginStart"
/// RSS Reader ログイン成功
#define kNotificationRSSLoginSuccess                            @"JBNotificationRSSLoginSuccess"
/// RSS Reader ログイン失敗
#define kNotificationRSSLoginFailure                            @"JBNotificationRSSLoginFailure"
/// RSS Reader セッション無効
#define kNotificationRSSLoginInvalid                            @"JBNotificationRSSLoginInvalid"
/// Bookmark ログイン処理終了
#define kNotificationModalBookmarkLoginControllerWillDismiss    @"JBNotificationBookmarkLoginControllerDismiss"
/// ModalViewControllerをdismissする
#define kNotificationModalViewControllerWillDismiss             @"JBNotificationModalViewControllerWillDismiss"

#pragma mark - Model
#define kXCDataModelName                            @"JBModel"


#pragma mark - Image
/// 透明画像
#define kImageCommonClear                            @"common_clear.png"


#pragma mark - Plist
/// ライセンス情報
#define kPlistAcknowledgements                      @"acknowledgements"
