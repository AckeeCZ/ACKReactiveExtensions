# Changelog

- please enter new entries in format 

```
- <description> (#<PR_number>, kudos to @<author>)
```

## main

## 7.1.0

- add extensions for running async operations as `SignalProducer` (#64, kudos to @olejnjak)
- remove default `JSONDecoder` for decode extension (#65, kudos to @olejnjak)

## 7.0.0

- use single ACKReactiveExtensions target (#63, kudos to @olejnjak)
- remove AlamofireImage extensions, moved to [Deprecated/AlamofireImage] for users relying on it (#62, kudos to @olejnjak)
- use Xcode 15.2 on CI ➡️ bump deployment target to iOS 12 (#61, kudos to @olejnjak)

# 6.2.0

- deprecate (more like remove) Realm and Marshal extensions from dependency managers distribution (#60, kudos to @olejnjak)

## 6.1.0
- update dependencies and deployment target to iOS 11.0, use Xcode 14 (#59, kudos to @olejnjak)

## 6.0.0 & 6.0.1
- update dependencies and deployment target to iOS 10.0 (#58, kudos to @vendulasvastal)

## 5.3.2

- use non-nil queue for `RealmCollection` observing (#56, kudos to @IgorRosocha + #57, kudos to @olejnjak)

## 5.3.1

- update dependencies (#54, kudos to @IgorRosocha)

## 5.3.0

- update dependencies, use Xcode 12.4 (#51, kudos to @olejnjak)
- update deployment target to iOS 9.0 (#53, kudos to @olejnjak)

## 5.2.0

- add extensions for `Codable` (#49, kudos to @olejnjak)

## 5.1.0

- add SwiftPM support (#47, kudos to @olejnjak)
- update `Realm` dependency to `~> 5.0` (#47, kudos to @olejnjak)

## 5.0.1

- fix `RealmCollection` bug in case when Realm data is modified before it sends initial change notification (#43, kudos to @olejnjak)

## 5.0

- update ReactiveSwift & ReactiveCocoa, use native Result (#41, kudos to @olejnjak)
- deprecate extensions which are available using Swift typed keypaths #40 (#42, kudos to @olejnjak)

## 4.1

- migrate to Xcode 10.2 and Swift 5 (#39, kudos to @olejnjak)

## 4.0.2

- fix dependencies 

## 4.0.1

- allow app extension API only (#36, kudos to @olejnjak)
