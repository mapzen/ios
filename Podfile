platform :ios, '9.3'
use_frameworks!

def shared_pods
  pod 'Pelias', :git => 'https://github.com/pelias/pelias-ios-sdk.git', :commit => '4b3d8a'
  pod 'OnTheRoad', '~> 1.0.0'
  pod 'Tangram-es', '~> 0.5.1'
end

target "ios-sdk" do
  shared_pods
end

target "ios-sdkTests" do
  shared_pods
end
