import UIKit

/**
 UIKit equivalent to SwiftUI's Capsule

 This view’s corner radius is the half of its shortest side. You’re responsible
 for setting the background yourself.
 */

public final class UACapsuleView: UIView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
