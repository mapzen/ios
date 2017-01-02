Pod::Spec.new do |s|

  s.name    = 'ios-sdk'
  s.version = '0.1.0'

  s.summary           = 'Mapzen iOS SDK'
  s.description       = 'Mapzen iOS SDK'
  s.homepage          = 'https://mapzen.com/products/ios/'
  s.license           = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author            = { 'Mapzen' => 'ios-support@mapzen.com' }
  s.social_media_url  = 'https://twitter.com/mapzen'
  s.documentation_url = 'https://mapzen.com/documentation/ios/'

  s.platform              = :ios
  s.ios.deployment_target = '9.0'

  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.dependency "Pelias"
    cs.dependency "OnTheRoad"
    cs.dependency "Tangram-es"
    cs.source_files => "src/*.swift"
  end
end
