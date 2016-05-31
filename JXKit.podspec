Pod::Spec.new do |s|
  s.name         = "JXKit"
  s.version      = "1.0.0"
  s.ios.deployment_target = '6.0'
  s.summary      = "A collection of iOS components."
  s.homepage     = "https://github.com/admxjx/JXKit"
  s.license      = "MIT"
  s.author             = { "admxjx" => "1103868202@qq.com" }
  s.social_media_url   = "https://github.com/admxjx/JXKit"
  s.source       = { :git => "https://github.com/admxjx/JXKit.git", :tag => s.version }
  s.source_files = 'JXKit/*.{h,m}'
  s.requires_arc = true
end
