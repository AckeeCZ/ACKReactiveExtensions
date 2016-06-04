#
# Be sure to run `pod lib lint ACKReactiveExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ACKReactiveExtensions'
  s.version          = '1.0.0'
  s.summary          = 'Useful extensions for ReactiveCocoa.'

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.ack.ee/Ackee/ACKReactiveExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jan Mísař' => 'misar.jan@gmail.com' }
  s.source           = { :git => 'git@gitlab.ack.ee:Ackee/ACKReactiveExtensions.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'ACKReactiveExtensions/*'

  s.default_subspec = 'UIKit'

  s.dependency 'ReactiveCocoa'

  s.subspec 'UIKit' do |uikit|
    uikit.source_files = 'ACKReactiveExtensions/UIKit/**/*'
  end

  s.subspec 'Argo' do |argo|
    argo.dependency 'Argo'
    argo.source_files = 'ACKReactiveExtensions/Argo/**/*'
  end

  s.subspec 'Reachability' do |reachability|
    reachability.dependency 'Reachability'
    reachability.source_files = 'ACKReactiveExtensions/Reachability/**/*'
  end

end
