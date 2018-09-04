# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SnackableTV' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SnackableTV
  # UI
  pod 'SDWebImage'
  pod 'RZTransitions', :git => 'https://github.com/austinzmchen/RZTransitions.git', :branch => 'release/ACCustomUI_1.1.3'
  pod 'Floaty', :git => 'https://github.com/austinzmchen/Floaty.git', :branch => 'release/ACCustomUI_1.3.1'
  
  # networking
  pod 'Alamofire'
  pod 'AlamofireObjectMapper', '~> 4.0'
  
  # utility
  pod 'Locksmith'
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # Push notification
  pod 'UrbanAirship-iOS-SDK'
  
  # single sign-on
  pod 'Gigya-iOS-SDK', '= 3.5.3'
  
  # deployment
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'HockeySDK', '~> 4.1.4'

  target 'SnackableTVTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SnackableTVUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
