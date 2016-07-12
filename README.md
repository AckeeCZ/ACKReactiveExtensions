# ACKReactiveExtensions

ACKReactiveExtensions contains extensions for views, label, controls and other UIKit classes for simple use with ReactiveCocoa. It also offers extensions for Argo, Reachability and probably much more in the future.

## Installation

ACKReactiveExtensions is available through [CocoaPods](http://cocoapods.org). You need to add Ackee private repo to your Cocoapods installation. See https://gitlab.ack.ee/Ackee/AckeePods for details. Then simply add the following line to your Podfile:

```ruby
pod "ACKReactiveExtensions"
```

## Subspecs
By using `pod "ACKReactiveExtensions"` you will get only general and UIKit extensions but there are also subspecs you can like/need.

```ruby
pod 'ACKReactiveExtensions/Argo'
pod 'ACKReactiveExtensions/Reachability'
pod 'ACKReactiveExtensions/SDWebImage'
```
These subspecs mostly require aditional dependencies (as Argo or Reachability) and you could not need it for your project. That's why it is separated to subspecs.

## Usage
Code contains only some useful extensions for existing classes, so just look to the code and use it.

## Author

j.m. misar.jan@gmail.com

## License

ACKReactiveExtensions has no license. We are ackee. Fuck license.