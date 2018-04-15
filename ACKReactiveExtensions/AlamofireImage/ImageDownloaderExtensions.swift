//
//  ImageDownloaderExtensions.swift
//  AlamofireImage
//
//  Created by Jakub Olejník on 15/04/2018.
//

import UIKit
import Alamofire
import ReactiveCocoa
import ReactiveSwift
import AlamofireImage

public struct ImageDownloadError: Error {
    public let underlyingError: Error
    
    public init(underlyingError: Error) {
        self.underlyingError = underlyingError
    }
}

extension Reactive where Base: ImageDownloader {
    public func loadImage(with url: URL, filter: ImageFilter? = nil) -> SignalProducer<UIImage, ImageDownloadError> {
        return SignalProducer { [weak base = base] observer, lifetime in
            guard let base = base else { observer.sendInterrupted(); return }
            let request = URLRequest(url: url)
            base.download(request, filter: filter) { response in
                switch response.result {
                case .success(let image):
                    observer.send(value: image)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: ImageDownloadError(underlyingError: error))
                }
            }
        }
    }
}
