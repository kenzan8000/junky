post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-acknowledgements.plist', 'junkbox/Resources/Plists/acknowledgements.plist', :remove_destination => true)
end
platform :ios, "5.0"
xcodeproj 'junkbox.xcodeproj'
# Connection
pod 'Reachability'
pod 'ISHTTPOperation', '~> 1.1.0'
# Core Data
pod 'NLCoreData'
# Social Bookmark
pod 'HatenaBookmarkSDK', :git => 'https://github.com/hatena/Hatena-Bookmark-iOS-SDK.git'
# User Interface
pod 'DejalActivityView'
pod 'EDStarRating'
pod 'MTStatusBarOverlay'
pod 'NJKWebViewProgress'
pod 'NKToggleOverlayButton', '~> 1.0.0'
pod 'QBFlatButton'
pod 'RNFrostedSidebar', '~> 0.2.0'
pod 'SSGentleAlertView'
pod 'SAMBadgeView', :git => 'https://github.com/soffes/SAMBadgeView.git'
# Font
pod 'ionicons'
# XML Parser
pod 'XMLDictionary'
