import UIKit

/*
 Scroll View subclass that automatically handles keyboard animations, designed to be used fullscreen.
 
 SETUP GUIDE
 In Interface Builder:
 
 - UAScrollView as root view:
 - Content Insets Adjustment Behaviour = Scrollable Axes
 - Preserve Superview Margins = false
 - Follow Readable Width = false
 - Safe Area Relative Margins = false
 
 - ContentView as only child of the UAScrollView:
 - Preserve Superview Margins = true
 - Follow Readable Width = true
 - Safe Area Relative Margins = true
 - Constraints to setup:
 contentView.top = superview.top
 contentView.bottom = superview.bottom
 contentView.leading = superview.leading
 contentView.trailing = superview.trailing
 contentView.width = superview.width
 contentView.height ≥ superview.height → Wired to `contentViewHeightConstraint` outlet
 
 - Then you can use an "equal spacing" vertical stack view inside the contentView,
 constrained to its layout margins (NOT to the safe area, which is now included
 in the margins).
 
 */

public final class UAScrollView: UIScrollView {
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    var keyboardHeight: CGFloat?
    @objc func adjustForKeyboard(notification: Notification) {
        guard let kbFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let kbHeight = convert(kbFrame.cgRectValue, from: window).height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentViewHeightConstraint?.constant = 0
            contentInset = .zero
            scrollIndicatorInsets = .zero
        } else {
            contentViewHeightConstraint?.constant = -kbHeight
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbHeight, right: 0)
            scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbHeight - safeAreaInsets.bottom, right: 0)
        }
    }
}
