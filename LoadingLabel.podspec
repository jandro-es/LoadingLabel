#
# Be sure to run `pod lib lint LoadingLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoadingLabel'
  s.version          = '1.0.0'
  s.summary          = 'UIView to represent a UILabel with a loading state.'

  s.description      = <<-DESC
UIView component composed of an animation and an UILabel, adding a loading state to a normal UIView.
                       DESC

  s.homepage         = 'https://github.com/jandro-es/LoadingLabel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jandro-es' => 'jandrob1978@gmail.com' }
  s.source           = { :git => 'https://github.com/jandro-es/LoadingLabel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/jandro_es'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LoadingLabel/Classes/**/*'
end
