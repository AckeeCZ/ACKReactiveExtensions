#
# Be sure to run `pod lib lint ACKReactiveExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ACKReactiveExtensions'
  s.version          = '1.2.4'
  s.summary          = 'Useful extensions for ReactiveCocoa.'

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.ack.ee/Ackee/ACKReactiveExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jan Mísař' => 'misar.jan@gmail.com' }
  s.source           = { :git => 'git@gitlab.ack.ee:Ackee/ACKReactiveExtensions.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

#s.source_files = ''

  s.default_subspec = 'Core','UIKit'

  s.dependency 'ReactiveSwift'
  s.dependency 'ReactiveCocoa', '>= 5.0'

  s.subspec 'Core' do |core|
    core.source_files = 'ACKReactiveExtensions/Core/**/*'
  end

  s.subspec 'UIKit' do |uikit|
    uikit.dependency 'ACKReactiveExtensions/Core'
    uikit.source_files = 'ACKReactiveExtensions/UIKit/**/*'
  end

  s.subspec 'Argo' do |argo|
    argo.dependency 'Argo', '~> 4.0'
    argo.source_files = 'ACKReactiveExtensions/Argo/**/*'
  end

  s.subspec 'Reachability' do |reachability|
    reachability.dependency 'ACKReactiveExtensions/Core'
    reachability.dependency 'Reachability'
    reachability.source_files = 'ACKReactiveExtensions/Reachability/**/*'
  end

  s.subspec 'SDWebImage' do |sdwebimage|
    sdwebimage.dependency 'ACKReactiveExtensions/Core'
    sdwebimage.dependency 'SDWebImage'
    sdwebimage.source_files = 'ACKReactiveExtensions/SDWebImage/**/*'
  end

  s.subspec 'WebKit' do |webkit|
    webkit.dependency 'ACKReactiveExtensions/Core'
    webkit.source_files = 'ACKReactiveExtensions/WebKit/**/*'
  end

end
