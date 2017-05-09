platform :ios, '9.3'
use_frameworks!

def shared_pods
  pod 'Mapzen-ios-sdk', :path => '.' 
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
