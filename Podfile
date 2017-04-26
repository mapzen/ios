platform :ios, '9.3'
use_frameworks!

def shared_pods
  pod 'Pelias', '~> 1.0.1'
  pod 'OnTheRoad', '~> 1.0.0'
  pod 'Tangram-es', '~> 0.5.2'
end

target "ios-sdk" do
  shared_pods
  pod "HockeySDK", '~> 4.1.4', :subspecs => ['CrashOnlyLib']
end

target "MapzenSDK" do
  shared_pods
end

target "MapzenSDKTests" do
  shared_pods
end
