#import "JBBookmarkConstant-Private.h"


#pragma mark - constant


/* **************************************************
                    HatenaBookmark
************************************************** */

/// Consumer Key
#define kConsumerKeyHatenaBookmark              kConsumerKeyHatenaBookmarkPrivate
/// Consumer Secret
#define kConsumerSecretHatenaBookmark           kConsumerSecretHatenaBookmarkPrivate

/// Host
#define kHostHatenaBookmark                     @"hatena.ne.jp"

/// HatenaBookmark
#define kURLHatenaBookmark                      @"http://b.hatena.ne.jp/"


/// Bookmark一覧をインポート
#define kAPIHatenaBookmarkDump                  [NSString stringWithFormat:@"%@dump",  kURLHatenaBookmark]
