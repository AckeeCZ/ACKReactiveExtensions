import UIKit
import ReactiveSwift
import SDWebImage


extension Reactive where Base: UIImageView {
    public var imageURL: BindingTarget<URL?> {
        return makeBindingTarget { $0.sd_setImage(with: $1, placeholderImage: nil) }
    }
}

extension Reactive where Base: SDWebImageDownloader {
    public func downloadImage(with url: URL, options: SDWebImageDownloaderOptions = SDWebImageDownloaderOptions()) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { sink, disposable in
            let task = self.base.downloadImage(with: url, options: options, progress: nil) { image, _, error, _ in
                guard let image = image else {
                    let e = error ?? NSError(domain: "", code: 0, userInfo: nil)
                    sink.send(error: e as NSError)
                    return
                }
                sink.send(value: image)
                sink.sendCompleted()
            }
            disposable.add({
                task?.cancel()
            })
        }
    }
}

private struct AssosiationKey {
    static var imageUrl: NSString = "sd.imageUrl"
}

extension UIImageView {
    @available(*, deprecated, renamed: "reactive.imageURL")
    public var rac_imageUrl: MutableProperty<URL?> {
        return lazyMutableProperty(self, &AssosiationKey.imageUrl, { [unowned self] url in
            self.sd_setImage(with: url, placeholderImage: nil)
            }, { [unowned self] in self.sd_imageURL() })
    }
}

extension SDWebImageDownloader {
    @available(*, deprecated, renamed: "reactive.downloadImage(with:options:)")
    public func rac_downloadImageWithURL(url: URL, options: SDWebImageDownloaderOptions = SDWebImageDownloaderOptions()) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { sink, disposable in
            let task = self.downloadImage(with: url, options: options, progress: nil) { image, _, error, _ in
                guard let image = image else {
                    let e = error ?? NSError(domain: "", code: 0, userInfo: nil)
                    sink.send(error: e as NSError)
                    return
                }
                sink.send(value: image)
                sink.sendCompleted()
            }
            disposable.add({ 
                task?.cancel()
            })
        }
    }
}
