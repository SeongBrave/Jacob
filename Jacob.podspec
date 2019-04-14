#
# Be sure to run `pod lib lint Jacob.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Jacob'
  s.version          = '0.0.1'
  s.summary          = '商品模块.'

  s.description      = <<-DESC
TODO: 包含商品列表 商品搜索 首页模块 等功能.
                       DESC

  s.homepage         = 'https://github.com/seongbrave/Jacob'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'seongbrave' => 'seongbrave@sina.com' }
  s.source           = { :git => 'https://github.com/seongbrave/Jacob.git', :tag => s.version.to_s }
  s.social_media_url = 'https://seongbrave.github.io/'

  s.ios.deployment_target = '8.0'
  s.dependency 'Bella', '~> 0.0.1'
  s.swift_version = "4.2"
  s.source_files = 'Jacob/Classes/**/*{.swift}'
  
   s.resource_bundles = {
       'Jacob' => ['Jacob/Assets/*{.storyboard,.xcassets}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
