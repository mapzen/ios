platform :ios, '9.0'
use_frameworks!

def shared_pods
  pod 'Pelias', :git => 'https://github.com/pelias/pelias-ios-sdk.git', :branch => 'master'
  pod 'OnTheRoad', :git => 'https://github.com/mapzen/on-the-road_ios.git', :branch => 'master'
  pod 'Tangram-es', :git => 'https://github.com/tangrams/ios-framework.git', :branch => 'master'
end

target "ios-sdk" do
  shared_pods
end

target "ios-sdkTests" do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end
