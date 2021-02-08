import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for v in views { addArrangedSubview(v) }
    }
    
    func addArrangedSubview(_ view: UIView?) {
        guard let v = view else { return }
        addArrangedSubview(v)
    }
    
    func empty() {
        while let view = self.arrangedSubviews.first {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func replaceArrangedSubview(at index: Int, with view: UIView) {
        guard arrangedSubviews.indices.contains(index) else {
            addArrangedSubview(view)
            return
        }
        
        let last = (index == arrangedSubviews.indices.upperBound - 1)
        
        let prev = arrangedSubviews[index]
        removeArrangedSubview(prev)
        prev.removeFromSuperview()
        
        if last {
            addArrangedSubview(view)
        }
        else {
            insertArrangedSubview(view, at: index)
        }
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0, _ subviews: [UIView] = []) {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}

public extension Array where Element: UIView {
    func arrangedInStackView(_ axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        return UIStackView(axis, alignment: alignment, distribution: distribution, spacing: spacing, self)
    }
}
