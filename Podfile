source 'https://github.com/CocoaPods/Specs'

platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

target 'ScoreReporter'
pod 'RZVinyl', '~> 3.0'
pod 'RZImport', '~> 3.0'
pod 'Alamofire', '~> 3.4'
pod 'Anchorage', '~> 2.0'
pod 'pop', '~> 1.0'
pod 'PINRemoteImage', '~> 2.1'
pod 'KVOController', '~> 1.1'

# Copy acknowledgements to the Settings.bundle

post_install do | installer |
  require 'fileutils'

  pods_acknowledgements_path = 'Pods/Target Support Files/Pods/Pods-Acknowledgements.plist'
  settings_bundle_path = Dir.glob("**/*Settings.bundle*").first

  if File.file?(pods_acknowledgements_path)
    puts 'Copying acknowledgements to Settings.bundle'
    FileUtils.cp_r(pods_acknowledgements_path, "#{settings_bundle_path}/Acknowledgements.plist", :remove_destination => true)
  end
end

