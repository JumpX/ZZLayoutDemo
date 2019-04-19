#
#  Be sure to run `pod spec lint ZZTabViewBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ZZTabViewBar"
  s.version      = "0.0.1"
  s.summary      = "A short description of ZZTabViewBar."
  s.description  = <<-DESC
                    ZZTabViewBar and ZZTabMutiPage
                   DESC

  s.homepage     = "https://github.com/JumpX/ZZTabViewBar.git"
  s.license      = "LICENSE"
  s.author             = { "Jungle" => "aosai123007@163.com" }
  s.source       = { :git => "", :tag => "#{s.version}" }
  s.platform     = :ios, "9.0"
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resource  = "Asset/image.xcassets"

end
