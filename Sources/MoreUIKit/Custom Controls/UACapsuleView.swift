import UIKit

/// UIKit equivalent to SwiftUI's Capsule

public final class UACapsuleView: UIView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
