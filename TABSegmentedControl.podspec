Pod::Spec.new do |s|
	
  s.name         = "TABSegmentedControl"
  s.version      = "0.1.1"
  s.summary      = "A segmented control alternative that subclasses UIScrollView"

  s.homepage     = "https://github.com/acrocat/TABSegmentedControl.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Dale Webster" => "dalewebster48@gmail.com" }
  s.social_media_url   = "http://twitter.com/greatirl"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/acrocat/TABSegmentedControl.git", :tag => "#{s.version}" }
  s.source_files  = "TABSegmentedControl/*.{swift}"

  s.framework = "UIKit"

end
