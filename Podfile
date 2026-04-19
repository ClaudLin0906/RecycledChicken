platform :ios, '13.0'

target 'RecycledChicken' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RecycledChicken

  pod 'M13Checkbox'
  pod 'DropDown', '2.3.13'
  pod 'GoogleMaps', '7.4.0'
  pod 'GooglePlaces'
  pod 'MKRingProgressView'
  pod 'Alamofire'
  pod 'SwiftGifOrigin', '~> 1.7.0'

  target 'RecycledChickenTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
