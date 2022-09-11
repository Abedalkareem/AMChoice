#
# Be sure to run `pod lib lint AMChoice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMChoice'
  s.version          = '1.0.0'
  s.summary          = 'Radio buttons and check boxes for iOS.'

  s.description      = <<-DESC
An amazing, easy to use, Radio buttons and check boxes for iOS.
                       DESC

  s.homepage         = 'https://github.com/abedalkareem/AMChoice'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'abedalkareem' => 'abedalkareem.omreyh@yahoo.com' }
  s.source           = { :git => 'https://github.com/abedalkareem/AMChoice.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AbedalkareemOmr'
  s.swift_version = '5.0'

  s.ios.deployment_target = '14.0'

  s.source_files = 'AMChoice/AMChoice/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AMChoice' => ['AMChoice/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
