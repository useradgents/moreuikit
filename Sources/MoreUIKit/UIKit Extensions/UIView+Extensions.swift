import UIKit

public extension UIView {
    func firstSuperview<T>(ofKind kind: T.Type) -> T? {
        return (superview as? T) ?? superview?.firstSuperview(ofKind: T.self)
    }
    
    func firstDescendent<T: UIView>(ofKind kind: T.Type) -> T? {
        if let first = subviews.first(where: { $0 is T }) as? T {
            return first
        }
        else { for sub in subviews {
            if let first = sub.firstDescendent(ofKind: kind) {
                return first
            }
        } }

        return nil
    }

    func wiggle() {
        let anim = CAKeyframeAnimation(keyPath: "transform.translation.x")
        anim.values = [16, -16, 12, -12, 6, -6, 2, -2, 0]
        anim.fillMode = CAMediaTimingFillMode.forwards
        anim.isRemovedOnCompletion = true
        anim.duration = 0.7
        layer.add(anim, forKey: nil)
    }
    
    static func performAnimations(_ animations: () -> Void, then: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(Optional(then))
        animations()
        CATransaction.commit()
    }
    
    @discardableResult
    func withBackgroundColor(_ bgColor: UIColor) -> Self {
        self.backgroundColor = bgColor
        return self
    }
    
    @discardableResult
    func sizedToFit() -> Self {
        self.sizeToFit()
        return self
    }
}

public extension UIView {
    func hideIf(_ h: Bool) { isHidden = h }
    func showIf(_ v: Bool) { isHidden = !v }
    func hide() { isHidden = true }
    func show() { isHidden = false }
    func toggleVisibility() { isHidden = !isHidden }
}

public extension CALayer {
    func hideIf(_ h: Bool) { isHidden = h }
    func showIf(_ v: Bool) { isHidden = !v }
    func hide() { isHidden = true }
    func show() { isHidden = false }
    func toggleVisibility() { isHidden = !isHidden }
}

public extension Collection where Element: UIView {
    func hideIf(_ h: Bool) { forEach { $0.isHidden = h } }
    func showIf(_ v: Bool) { forEach { $0.isHidden = !v } }
    func hide() { forEach { $0.isHidden = true } }
    func show() { forEach { $0.isHidden = false } }
    func toggleVisibility() { forEach { $0.isHidden = !$0.isHidden } }
    var enclosingRect: CGRect {
        return reduce(.null, { $0.union($1.frame) })
    }
}

public extension Collection where Element: CALayer {
    func hideIf(_ h: Bool) { forEach { $0.isHidden = h } }
    func showIf(_ v: Bool) { forEach { $0.isHidden = !v } }
    func hide() { forEach { $0.isHidden = true } }
    func show() { forEach { $0.isHidden = false } }
    func toggleVisibility() { forEach { $0.isHidden = !$0.isHidden } }
}
