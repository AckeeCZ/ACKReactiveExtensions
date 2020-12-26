Pod::Spec.new do |s|
  s.name             = 'ACKReactiveExtensions'
  s.version          = '5.2.0'
  s.summary          = 'Useful extensions for ReactiveCocoa.'
  s.description      = <<-DESC
  Use ReactiveCocoa with various iOS components.
                       DESC
  s.homepage         = 'https://github.com/AckeeCZ/ACKReactiveExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ackee' => 'info@ackee.cz' }
  s.source           = { :git => 'https://github.com/AckeeCZ/ACKReactiveExtensions.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.3'
  s.swift_version    = '5.0'
  s.default_subspec  = 'Core','UIKit'
  s.dependency 'ReactiveCocoa', '~> 11.0'
  s.dependency 'ReactiveSwift', '~> 6.5'

  s.subspec 'Core' do |core|
    core.source_files = 'ACKReactiveExtensions/Core/*.swift'
  end

  s.subspec 'UIKit' do |uikit|
    uikit.dependency 'ACKReactiveExtensions/Core'
    uikit.source_files = 'ACKReactiveExtensions/UIKit/*.swift'
  end

  s.subspec 'WebKit' do |webkit|
    webkit.dependency 'ACKReactiveExtensions/Core'
    webkit.source_files = 'ACKReactiveExtensions/WebKit/*.swift'
  end

  s.subspec 'Realm' do |realm|
    realm.ios.deployment_target = '9.0'
    realm.dependency 'ACKReactiveExtensions/Core'
    realm.dependency 'RealmSwift', '~> 10.5'
    realm.source_files = 'ACKReactiveExtensions/Realm/*.swift'
  end

  s.subspec 'Marshal' do |marshal|
    marshal.dependency 'ACKReactiveExtensions/Core'
    marshal.dependency 'Marshal', '~> 1.2'
    marshal.source_files = 'ACKReactiveExtensions/Marshal/*.swift'
  end
  
  s.subspec 'AlamofireImage' do |alamofire|
    alamofire.dependency 'ACKReactiveExtensions/Core'
    alamofire.dependency 'AlamofireImage', '~> 3.3'
    alamofire.source_files = 'ACKReactiveExtensions/AlamofireImage/*.swift'
  end

end
