import UIKit
import Slab

public extension UIAlertController {
    
    convenience init(error: Error?) {
        self.init(title: "Generic.error"†, message: error?.localizedDescription ?? "Generic.errorMessage"†, preferredStyle: .alert)
        addAction(UIAlertAction(title: "Generic.ok"†, style: .default, handler: nil))
    }
    
    convenience init(error: Error) {
        self.init(title: "Generic.error"†, message: error.localizedDescription, preferredStyle: .alert)
        addAction(UIAlertAction(title: "Generic.ok"†, style: .default, handler: nil))
    }
    
}
