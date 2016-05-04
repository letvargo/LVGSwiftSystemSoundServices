Pod::Spec.new do |s|
  s.name             = "LVGSwiftSystemSoundServices"
  s.version          = "1.0.1"
  s.summary          = "A Swift wrapper around Audio Toolbox's System Sound Services."
  s.description      = <<-DESC
  LVGSwiftSystemSoundServices wraps Audio Toolbox's System Sound Services in an easy to use set of Swift functions. It includes a protocol, SystemSoundType, that lets you easily add system sound functionality to any object. It also includes the SystemSound class that loads and plays system sounds.
                       DESC

  s.homepage         = "https://github.com/letvargo/LVGSwiftSystemSoundServices"
  s.license          = 'MIT'
  s.author           = { "Aaron Rasmussen" => "letvargo@gmail.com" }
  s.source           = { :git => 'https://github.com/letvargo/LVGSwiftSystemSoundServices.git', :tag => '1.0.1' }
  s.social_media_url = 'https://twitter.com/letvargo'
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.frameworks = 'AudioToolbox'
  s.dependency 'LVGUtilities', '~> 1.0'
end