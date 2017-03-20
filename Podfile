platform :ios, '9.3'
use_frameworks!

def shared_pods
  pod 'Pelias', '~> 1.0.0-beta'
  pod 'OnTheRoad', :git => 'https://github.com/mapzen/on-the-road_ios.git', :commit => '603fe7a'
  pod 'Tangram-es', :git => 'https://github.com/tangrams/ios-framework.git', :branch => 'master', :commit => 'a1b1338'
end

target "ios-sdk" do
  shared_pods
end

target "ios-sdkTests" do
  shared_pods
end
