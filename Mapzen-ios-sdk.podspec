Pod::Spec.new do |s|

  s.name    = 'Mapzen-ios-sdk'
  s.version = '0.1.1'

  s.summary           = 'Mapzen iOS SDK'
  s.description       = 'The Mapzen iOS SDK is a thin wrapper that packages up everything you need to use Mapzen services in your iOS applications. It also simplifies setup, installation, API key management, and generally makes your life better.'
  s.homepage          = 'https://mapzen.com/projects/mobile/'
  s.license           = { :type => 'Apache License, Version 2.0', :file => 'LICENSE.md' }
  s.author            = { 'Mapzen' => 'ios-support@mapzen.com' }
  s.social_media_url  = 'https://twitter.com/mapzen'
  s.documentation_url = 'https://mapzen.com/documentation/ios/'
  s.source           =  { :git => 'https://github.com/mapzen/ios.git', :tag => "v#{s.version}" }

  s.platform              = :ios
  s.ios.deployment_target = '9.3'

  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.dependency 'Pelias', '~> 1.0.0-beta'
    cs.dependency 'OnTheRoad', '~> 1.0.0-beta'
    cs.dependency 'Tangram-es', '~> 0.4.1'
    cs.source_files = "src/*.swift"
    cs.resources = [ 'images/*.png', 'tangram/*' ]
  end
end
