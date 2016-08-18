import UIKit
import ReactiveCocoa
import SDWebImage

private struct AssosiationKey {
    static var imageUrl: NSString = "sd.imageUrl"
}

extension UIImageView {
    public var rac_imageUrl: MutableProperty<NSURL?> {
        return lazyMutableProperty(self, &AssosiationKey.imageUrl, { url in
            self.sd_setImageWithURL(url, placeholderImage: nil)
            }, { [unowned self] in self.sd_imageURL() })
    }
}

extension SDWebImageDownloader {
    public func rac_downloadImageWithURL(url: NSURL, options: SDWebImageDownloaderOptions = SDWebImageDownloaderOptions()) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { sink, disposable in
            let task = self.downloadImageWithURL(url, options: options, progress: nil) { image, _, error, _ in
                guard let image = image else {
                    sink.sendFailed(error ?? NSError(domain: "", code: 0, userInfo: nil))
                    return
                }
                sink.sendNext(image); sink.sendCompleted()
            }
            disposable.addDisposable { task?.cancel() }
        }
    }
}
