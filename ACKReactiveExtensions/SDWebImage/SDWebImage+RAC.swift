import UIKit
import ReactiveSwift
import SDWebImage


extension Reactive where Base: UIImageView {
    /// Binding target that will download image from given URL using SDWebImage
    public var imageURL: BindingTarget<URL?> {
        return makeBindingTarget { $0.sd_setImage(with: $1, placeholderImage: nil) }
    }
}

extension Reactive where Base: SDWebImageManager {
    public func loadImage(with url: URL, options: SDWebImageOptions = SDWebImageOptions()) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { sink, disposable in
            let task = self.base.loadImage(with: url, options: options, progress: nil) { image, _, error, _, _, _ in
                guard let image = image else {
                    let e = error ?? NSError(domain: "", code: 0, userInfo: nil)
                    sink.send(error: e as NSError)
                    return
                }
                sink.send(value: image)
                sink.sendCompleted()
            }
            disposable.add {
                task?.cancel()
            }
        }
    }
}
