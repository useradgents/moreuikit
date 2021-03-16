import UIKit

/**
 A `UIBarButtonItem` that has an activity indicator (aka spinner).
 
 The spinner inherits the tint color.
 */

public final class UASpinnerBarButtonItem: UIBarButtonItem {
    /**
     Create a new `UIBarButtonItem`
     
     - Parameter color: the tint color for the spinner (default: `.gray`)
     */
    public init(color: UIColor = .gray) {
        super.init()
        let ac: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            ac = UIActivityIndicatorView(style: .medium)
        } else {
            ac = UIActivityIndicatorView(style: .gray)
        }
        ac.color = color
        customView = ac
        startAnimating()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let ac: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            ac = UIActivityIndicatorView(style: .medium)
        } else {
            ac = UIActivityIndicatorView(style: .gray)
        }
        ac.color = tintColor ?? UIColor.gray
        customView = ac
        startAnimating()
    }
    
    /// Animate the spinner
    public func startAnimating() {
        (customView as? UIActivityIndicatorView)?.startAnimating()
    }
    
    /// Stop animating the spinner
    public func stopAnimating() {
        (customView as? UIActivityIndicatorView)?.stopAnimating()
    }
    
    public override var tintColor: UIColor? {
        didSet {
            (customView as? UIActivityIndicatorView)?.color = tintColor
        }
    }
}
