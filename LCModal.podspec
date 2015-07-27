Pod::Spec.new do |s|
  s.name             = "LCModal"
  s.version          = File.read('VERSION')
  s.summary          = "An Objective-C category to present a semi modal view controller"
  s.description      = <<-DESC
                       An Objective-C category to present a semi modal view controller with a nice push back effect for the presenting view controller.
                       DESC
  s.homepage         = "https://github.com/ThXou/LCModal"
  s.screenshots      = "https://raw.githubusercontent.com/ThXou/LCModal/master/screenshot_1.png"
  s.license          = 'MIT'
  s.author           = { "ThXou" => "yo@thxou.com" }
  s.source           = { :git => "https://github.com/ThXou/LCModal.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thxou'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Source'
end