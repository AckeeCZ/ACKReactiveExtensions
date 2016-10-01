import UIKit
import ReactiveSwift
import SDWebImage

private struct AssosiationKey {
    static var imageUrl: NSString = "sd.imageUrl"
}

extension UIImageView {
    public var rac_imageUrl: MutableProperty<URL?> {
        return lazyMutableProperty(self, &AssosiationKey.imageUrl, { [unowned self] url in
            self.sd_setImage(with: url, placeholderImage: nil)
            }, { [unowned self] in self.sd_imageURL() })
    }
}

extension SDWebImageDownloader {
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
