#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "JDReleaseNote"
  s.version          = "0.1.0"
  s.summary          = "A short description of JDReleaseNote."
  s.description      = <<-DESC
                       An optional longer description of JDReleaseNote

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/jayDLabs/JDReleaseNote"
  s.screenshots      = "www.example.com/screenshots_1"
  s.license          = 'MIT'
  s.author           = { "Jean-Baptiste Denoual" => "denoual.jeanbaptiste@gmail.com" }
  s.source           = { :git => "https://github.com/jayDLabs/JDReleaseNote.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JbDenoual'

  # s.platform     = :ios, '5.0'
  # s.ios.deployment_target = '5.0'
  s.requires_arc = true

  s.source_files = 'JDReleaseNote/JDReleaseNote/*.{h,m}'
  s.resources = 'JDReleaseNote/JDReleaseNote/*.png', 'JDReleaseNote/JDReleaseNote/*.xib', 'JDReleaseNote/JDReleaseNote/ReleaseNotes.plist'

  # s.public_header_files = 'JDReleaseNote/JDReleaseNote/*.h'
  # s.frameworks = 'Foundation'
end
