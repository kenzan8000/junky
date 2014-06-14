#pragma mark - constant


/// RSS系通信の並列実行するスレッド数最大
#define kMaxOperationCountOfRSSConnection        3


/* **************************************************
                    Livedoor Reader
************************************************** */

/// Livedoor Reader
#define kURLLivedoorReader                       @"http://reader.livedoor.com/"
/// livedoor IDやパスワードを忘れた方へ
#define kURLLivedoorReaderReminder               @"https://member.livedoor.com/reminder/"

/**
 * Livedoor Reader ログイン
 * @param livedoor_id livedoor_id
 * @param password password
 * @param .sv 値は"reader"
 * @responceにcookieが入る
 */
#define kURLLivedoorReaderLogin1                 @"http://member.livedoor.com/login"
/// Login2
#define kURLLivedoorReaderLogin2                 @"https://member.livedoor.com/login/index"
/// Login3
#define kURLLivedoorReaderLogin3                 kURLLivedoorReader
/// Cookie1
#define kCookieNamesLivedoorReaderLogin          @[@"member_sid",]
/// Cookie1のドメイン
#define kCookieDomainsLivedoorReaderLogin        @[@".member.livedoor.com",]
/// Cookie2
#define kSessionNamesLivedoorReaderLogin         @[@".LRC", @".LH", @".LL",]
/// Cookieドメイン2
#define kSessionDomainsLivedoorReaderLogin       @[@".livedoor.com", @".livedoor.com", @".livedoor.com",]
/// Cookie3(ApiKey)
#define kApiKeyLivedoorReader                    @"reader_sid"
/// Cookie3のドメイン
#define kApiKeyDomainLivedoorReader              @".reader.livedoor.com"
/// Host
#define kHostLivedoorReader                      @"livedoor.com"


/// Livedoor Reader API
#define kAPILivedoorReader                       [NSString stringWithFormat:@"%@api/", kURLLivedoorReader]
/// ApiKey %@=ApiKey
#define kQueryLivedoorReaderApiKeyFirstParameter [NSString stringWithFormat:@"?ApiKey=%@", @"%@"]
/// ApiKey %@=ApiKey
#define kQueryLivedoorReaderApiKey               [NSString stringWithFormat:@"&ApiKey=%@", @"%@"]


/// POST urlの中からフィードを探す %@=url
#define kAPILivedoorReaderFeedDiscover           [NSString stringWithFormat:@"%@feed/discover?url=%@",  kAPILivedoorReader, @"%@"]
/// POST feedlinkのフィードを追加 %@=feedlink
#define kAPILivedoorReaderFeedSubscribe          [NSString stringWithFormat:@"%@feed/subscribe?feedlink=%@",  kAPILivedoorReader, @"%@"]
/// POST subscribe_idのフィードのレートを変更 %@=subscribe_id
#define kAPILivedoorReaderFeedSetRate            [NSString stringWithFormat:@"%@feed/set_rate?subscribe_id=%@&rate=%@",  kAPILivedoorReader, @"%@", @"%@"]

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


/// Livedoor Reader Username NSUserDefaults Key
#define kUserDefaultsLivedoorReaderUsername      @"UserDefaultsLivedoorReaderUsername"
/// Livedoor Reader Password NSUserDefaults Key
#define kUserDefaultsLivedoorReaderPassword      @"UserDefaultsLivedoorReaderPassword"
/// Livedoor Reader ApiKey
#define kUserDefaultsLivedoorReaderApiKey        @"UserDefaultsLivedoorReader_reader_sid"
/// Livedoor Reader Session
#define kUserDefaultsLivedoorReaderSession       @"UserDefaultsLivedoorReader_session"


/// スターの最大(5つ星)
#define kLivedoorReaderMaxRate                    5
/// スターのラベル
#define kLivedoorReaderRateLabels                 @[ \
    @"★★★★★", \
    @"★★★★☆", \
    @"★★★☆☆", \
    @"★★☆☆☆", \
    @"★☆☆☆☆", \
    @"☆☆☆☆☆", \
]
