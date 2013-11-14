#pragma mark - constant


/// Livedoor Reader
#define kURLLivedoorReader                       @"http://reader.livedoor.com/"


/**
 * Livedoor Reader ログイン
 * @param livedoor_id livedoor_id
 * @param password password
 * @param .sv 値は"reader"
 * @responceにcookieが入る
 */
#define kURLLivedoorReaderLogin                  [NSString stringWithFormat:@"https://member.livedoor.com/login/index?livedoor_id=%@&password=%@", @"%@", @"%@"]
/// セッションのCookie名
#define kSessionNamesLivedoorReaderLogin         @[@".LRC", @".LH", @".LL",]
/// セッションのCookieドメイン
#define kSessionDomainsLivedoorReaderLogin       @[@".livedoor.com", @".livedoor.com", @".livedoor.com",]
/// ApiKey
#define kApiKeyLivedoorReader                    @"member_sid"
/// ApiKeyのCookieのドメイン
#define kApiKeyDomainLivedoorReader              @".member.Livedoor.com"


/// Livedoor Reader API
#define kAPILivedoorReader                       [NSString stringWithFormat:@"%@api/", kURLLivedoorReader]
/// ApiKey %@=ApiKey
#define kQueryLivedoorReaderApiKey               [NSString stringWithFormat:@"&ApiKey=%@", @"%@"]


/// POST urlの中からフィードを探す %@=url
#define kAPILivedoorReaderFeedDiscover           [NSString stringWithFormat:@"%@feed/discover?url=%@",  kAPILivedoorReader, @"%@"]
/// POST feedlinkのフィードを追加 %@=feedlink
#define kAPILivedoorReaderFeedSubscribe          [NSString stringWithFormat:@"%@feed/subscribe?feedlink=%@",  kAPILivedoorReader, @"%@"]
/// POST subscribe_idのフィードのレートを変更 %@=subscribe_id
#define kAPILivedoorReaderFeedSetRate            [NSString stringWithFormat:@"%@feed/set_rate?subscribe_id=%@",  kAPILivedoorReader, @"%@"]


/// POST 未読フィード一覧を取得
#define kAPILivedoorReaderSubsUnread             [NSString stringWithFormat:@"%@subs?unread=1",  kAPILivedoorReader]
/// POST subscribe_idのフィードの未読件数取得 %@=subscribe_id
#define kAPILivedoorReaderUnread                 [NSString stringWithFormat:@"%@unread?subscribe_id=%@",  kAPILivedoorReader, @"%@"]
/// POST subscribe_idのフィードを既読化 %@=subscribe_id

#define kAPILivedoorReaderTouchAll               [NSString stringWithFormat:@"%@touch_all?subscribe_id=%@",  kAPILivedoorReader, @"%@"]

/// POST ピンに登録している一覧を取得
#define kAPILivedoorReaderPinAll                  [NSString stringWithFormat:@"%@pin/all",  kAPILivedoorReader]
/// POST ピンにtitleをつけてlinkを追加 %@=title %@=link
#define kAPILivedoorReaderPinAdd                  [NSString stringWithFormat:@"%@pin/add?title=%@&link=%@",  kAPILivedoorReader, @"%@", @"%@"]
/// POST ピンからlinkを消去 %@=link
#define kAPILivedoorReaderPinRemove               [NSString stringWithFormat:@"%@pin/remove?link=%@",  kAPILivedoorReader, @"%@"]
/// POST ピン全消去
#define kAPILivedoorReaderPinClear                [NSString stringWithFormat:@"%@pin/clear",  kAPILivedoorReader]


