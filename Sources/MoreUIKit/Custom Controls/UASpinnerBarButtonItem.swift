import UIKit

public final class UASpinnerBarButtonItem: UIBarButtonItem {
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
    
    public func startAnimating() {
        (customView as? UIActivityIndicatorView)?.startAnimating()
    }
    
    public func stopAnimating() {
        (customView as? UIActivityIndicatorView)?.stopAnimating()
    }
    
    public override var tintColor: UIColor? {
        didSet {
            (customView as? UIActivityIndicatorView)?.color = tintColor
        }
    }
}
