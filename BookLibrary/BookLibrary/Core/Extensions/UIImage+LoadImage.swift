import UIKit
import ObjectiveC

private let imageCache = NSCache<NSURL, UIImage>()

private var imageTaskKey: UInt8 = 0
private var imageURLKey: UInt8 = 0

extension UIImageView {
    
    private var currentImageTask: URLSessionDataTask? {
        get {
            objc_getAssociatedObject(self, &imageTaskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(
                self,
                &imageTaskKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private var currentImageURL: URL? {
        get {
            objc_getAssociatedObject(self, &imageURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(
                self,
                &imageURLKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private func applyPlaceholder(_ placeholder: UIImage?) {
        let fallback = UIImage(systemName: "book.closed")?
                .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        image = placeholder ?? fallback
        contentMode = .scaleAspectFit
        tintColor = nil
    }
    
    func setImage(from url: URL?, placeholder: UIImage? = nil) {
        
        currentImageTask?.cancel()
        currentImageTask = nil
        currentImageURL = nil
        
        applyPlaceholder(placeholder)
        
        guard let url else {
            return
        }
        
        currentImageURL = url
        
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            image = cachedImage
            contentMode = .scaleAspectFill
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            if error != nil {
                DispatchQueue.main.async {
                    self.applyPlaceholder(placeholder)
                }
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode,
                let data,
                let downloadedImage = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    self.applyPlaceholder(placeholder)
                }
                return
            }
            
            imageCache.setObject(downloadedImage, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                guard self.currentImageURL == url else {
                    self.applyPlaceholder(placeholder)
                    return
                }
                
                self.image = downloadedImage
                self.contentMode = .scaleAspectFill
                self.tintColor = .clear
            }
        }
        
        currentImageTask = task
        task.resume()
    }
    
    func cancelImageLoading(placeholder: UIImage? = nil) {
        currentImageTask?.cancel()
        currentImageTask = nil
        currentImageURL = nil
        applyPlaceholder(placeholder)
    }
}
