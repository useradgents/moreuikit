import UIKit

public extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) {
        self.init(image: image)
        self.contentMode = contentMode
        if let c = tintColor { self.tintColor = c }
    }
    
    convenience init(url: URL?, placeholder: UIImage? = nil, contentMode: UIView.ContentMode = .center, placeholderContentMode: UIView.ContentMode? = nil, cache: URLRequest.CachePolicy = .returnCacheDataElseLoad, then: ((UIImage?)->())? = nil) {
        
        self.init(image: placeholder)
        self.contentMode = placeholderContentMode ?? contentMode
        
        if let url = url {
            self.load(url: url, placeholder: nil, contentMode: contentMode, placeholderContentMode: placeholderContentMode, cache: cache, then: then)
        }
    }
    
    func load(url: URL, placeholder: UIImage? = nil, contentMode: UIView.ContentMode = .center, placeholderContentMode: UIView.ContentMode? = nil, cache: URLRequest.CachePolicy = .returnCacheDataElseLoad, then: ((UIImage?)->())? = nil) {
        
        if let p = placeholder {
            self.image = p
            self.contentMode = placeholderContentMode ?? contentMode
        }
        URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: cache, timeoutInterval: 60)) { [weak self] (data, response, error) in
            
            guard let sself = self else { return }
            guard let d = data, let img = UIImage(data: d) else {
                DispatchQueue.main.async {
                    then?(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                sself.image = img
                sself.contentMode = contentMode
                then?(img)
            }
            
            }.resume()
    }
}

public extension UIImage {
    static func template(named name: String, in bundle: Bundle? = nil, compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {
        UIImage(named: name, in: bundle, compatibleWith: traitCollection)?.withRenderingMode(.alwaysTemplate)
    }
    
    @available(iOS 13.0, *)
    static func template(named name: String, in bundle: Bundle? = nil, with configuration: Configuration? = nil) -> UIImage? {
        UIImage(named: name, in: bundle, with: configuration)?.withRenderingMode(.alwaysTemplate)
    }
    
    @available(iOS 13.0, *)
    static func template(systemName name: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {
        UIImage(systemName: name, compatibleWith: traitCollection)?.withRenderingMode(.alwaysTemplate)
    }
    
    @available(iOS 13.0, *)
    static func template(systemName: String, withConfiguration configuration: Configuration? = nil) -> UIImage? {
        UIImage(systemName: systemName, withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
    }
    
    static func pixel(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(size.makeRect())
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    static let clearPixel = UIImage.pixel(.clear)
    static let blackPixel = UIImage.pixel(.black)
    static let whitePixel = UIImage.pixel(.white)
}
