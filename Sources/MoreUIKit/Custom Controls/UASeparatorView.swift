import UIKit

/**
 A simplistic view replicating SwiftUI’s `Separator`.
 
 This view has just a default background color, and an intrinsic height of 1 pixel (not 1 point).
 */

public final class UASeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        if #available(iOS 13.0, *) {
            backgroundColor = .separator
        } else {
            backgroundColor = .lightGray
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: UIScreen.main.hairline)
    }
}
