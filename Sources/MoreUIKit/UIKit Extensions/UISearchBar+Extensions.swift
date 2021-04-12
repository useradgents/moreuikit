import UIKit

extension UISearchBar {
    // SearchTextField is only available from iOS 13. Before, we have to use this.
    public var textColor: UIColor? {
        get { (value(forKey: "searchField") as? UITextField)?.textColor }
        set { (value(forKey: "searchField") as? UITextField)?.textColor = newValue }
    }
}

