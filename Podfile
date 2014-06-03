post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-acknowledgements.plist', 'junkbox/Resources/Plists/acknowledgements.plist', :remove_destination => true)
end
platform :ios, "6.0"
xcodeproj 'junkbox.xcodeproj'
# Connection
pod 'Reachability'
pod 'ISHTTPOperation', '~> 1.1.0'
# Core Data
pod 'NLCoreData'
# Social Bookmark
pod 'HatenaBookmarkSDK'
# User Interface
pod 'EDStarRating'
pod 'MTStatusBarOverlay'
pod 'NJKWebViewProgress'
pod 'NKToggleOverlayButton', '~> 2.0.0'
pod 'QBFlatButton'
pod 'RNFrostedSidebar', '~> 0.2.0'
pod 'SSGentleAlertView'
pod 'SAMBadgeView'
pod 'TYMActivityIndicatorView'
pod 'YLGIFImage'
# Font
pod 'ionicons'
# XML Parser
pod 'XMLDictionary'
