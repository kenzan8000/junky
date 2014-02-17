#Junky
===============

## What is Junky?
Junky is iOS application which is Livedoor Reader and Hatena Bookmark client.
You can read internet news like a junky by iPhone.

## How to install
1. Input terminal. (You have to install CocoaPods. http://cocoapods.org/)
```terminal
git clone https://github.com/kenzan8000/junky.git
cd junky
pod install
```
2. Register your account on Hatena Developer Center.
http://developer.hatena.ne.jp/
3. Make your Hatena application and get your application consumer key and consumer secret.
4. Add /junkbox/Classes/Bookmark/JBBookmarkConstant-Private.h.
```objective-c
/// JBBookmarkConstant-Private.h

#pragma mark - constant

/* **************************************************
                    HatenaBookmark
************************************************** */
/// Consumer Key
#define kConsumerKeyHatenaBookmarkPrivate @"YOUR CONSUMER KEY!!"
/// Consumer Secret
#define kConsumerSecretHatenaBookmarkPrivate @"YOUR CONSUMER SECRET!!"

```

## License
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) 2014 Kenzan8000 <kenzan8000@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
