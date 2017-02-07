platform :ios, '9.3'
use_frameworks!

def shared_pods
  pod 'Pelias', '~> 1.0.0-beta'
  pod 'OnTheRoad', '~> 1.0.0-beta'
  pod 'Tangram-es', '~> 0.4.1'
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
