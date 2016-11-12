source 'https://github.com/CocoaPods/Specs'

platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

target 'ScoreReporter'
pod 'Alamofire', '~> 4.0'
pod 'Anchorage', '~> 3.0'
pod 'PINRemoteImage', '~> 2.1'
pod 'KVOController', '~> 1.2'
#pod 'MapSnap'

# Copy acknowledgements to the Settings.bundle

post_install do | installer |
  require 'fileutils'
  
#  installer.pods_project.targets.each do |target|
#      target.build_configurations.each do |config|
#          config.build_settings['SWIFT_VERSION'] = '2.3'
#      end
#  end

  pods_acknowledgements_path = 'Pods/Target Support Files/Pods-ScoreReporter/Pods-ScoreReporter-acknowledgements.plist'
  settings_bundle_path = Dir.glob("**/*Settings.bundle*").first

  if File.file?(pods_acknowledgements_path)
    puts 'Copying acknowledgements to Settings.bundle'
    FileUtils.cp_r(pods_acknowledgements_path, "#{settings_bundle_path}/Acknowledgements.plist", :remove_destination => true)
  end
end

