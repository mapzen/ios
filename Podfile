platform :ios, '9.3'
use_frameworks!

def shared_pods
  #pod "Pelias", :git => 'https://github.com/pelias/pelias-ios-sdk.git', :branch => 'swift4'
  pod 'Mapzen-ios-sdk', :path => '.'
end

target "ios-sdk" do
  shared_pods
  pod "HockeySDK", '~> 4.1.4', :subspecs => ['CrashOnlyLib']
end

target "MapzenSDK" do
  #pod "Pelias", :git => 'https://github.com/pelias/pelias-ios-sdk.git', :branch => 'swift4'
  shared_pods
end

target "MapzenSDKTests" do
  shared_pods
end

target "SampleApp-Objc" do
  shared_pods
end

target "SampleApp-ObjcTests" do
  shared_pods
end

post_install do |installer|
  # Your list of targets here.
myTargets = ['Pelias']

installer.pods_project.targets.each do |target|
if myTargets.include? target.name
target.build_configurations.each do |config|
  config.build_settings['SWIFT_VERSION'] = '3.2'
end
end
end
end
