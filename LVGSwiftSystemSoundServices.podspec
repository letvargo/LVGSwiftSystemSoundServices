#
# Be sure to run `pod lib lint LVGSwiftSystemSoundServices.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LVGSwiftSystemSoundServices"
  s.version          = "0.1.0"
  s.summary          = "A Swift wrapper around Audio Toolbox's System Sound Services."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  LVGSwiftSystemSoundServices wraps Audio Toolbox's System Sound Services in an easy to use set of Swift functions. It includes a protocol, SystemSoundType, that lets you easily add system sound functionality to any object. It also includes the SystemSound class that loads and plays system sounds.
                       DESC

  s.homepage         = "https://github.com/letvargo/LVGSwiftSystemSoundServices"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Aaron Rasmussen" => "letvargo@gmail.com" }
  s.source           = { :git => '/Users/doofnugget/Documents/projects/Podspecs/LVGSwiftSystemSoundServices/', :tag => '0.1.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LVGSwiftSystemSoundServices' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'AudioToolbox'
  # s.dependency 'AFNetworking', '~> 2.3'
end
