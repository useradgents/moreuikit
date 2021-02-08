import UIKit

// Create UILayoutPriorities with just an integer literal.
// eg. myConstraint.priority = 1000
extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self = UILayoutPriority(Float(value))
    }
}

extension NSLayoutConstraint {
    @discardableResult
    public func withPriority(_ p: UILayoutPriority?) -> NSLayoutConstraint {
        if let p = p { priority = p }
        return self
    }
    
    public convenience init(item: Any, attribute: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, constant c: CGFloat) {
        self.init(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: c)
    }
}

// Shorthand for translatesAutoresizingMaskIntoConstraints

extension UIView {
    public var autolayout: Bool {
        get { !translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = !newValue }
    }
    
    @discardableResult
    public func autolaidout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}


// Hugging and compression resistance

extension UIView {
    
    @discardableResult
    public func hugged(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required) -> Self {
        if axes.isHorizontal { setContentHuggingPriority(priority, for: .horizontal) }
        if axes.isVertical   { setContentHuggingPriority(priority, for: .vertical)   }
        return self
    }
    
    @discardableResult
    public func incompressible(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required) -> Self {
        if axes.isHorizontal { setContentCompressionResistancePriority(priority, for: .horizontal) }
        if axes.isVertical   { setContentCompressionResistancePriority(priority, for: .vertical)   }
        return self
    }
    
}

// Fixing width and height

extension UIView {
    
    @discardableResult
    public func withSize(_ fixedSize: CGSize, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, constant: fixedSize.width).withPriority(priority))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, constant: fixedSize.height).withPriority(priority))
        return self
    }
    
    @discardableResult
    public func withSize(w width: CGFloat, h height: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, constant: width).withPriority(priority))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, constant: height).withPriority(priority))
        return self
    }
    
    @discardableResult
    public func withWidth(_ width: CGFloat, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, constant: width).withPriority(priority))
        return self
    }
    
    @discardableResult
    public func withHeight(_ height: CGFloat, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, constant: height).withPriority(priority))
        return self
    }
    
}

// Centering in superview

extension UIView {
    @discardableResult
    public func centeredInSuperview(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required, avoidingOverflow: UILayoutPriority? = nil) -> Self {
        guard let s = superview else { return self }
        
        if axes.isHorizontal {
            s.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: s, attribute: .centerX, multiplier: 1, constant: 0).withPriority(priority))
            
            if let op = avoidingOverflow {
                s.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: s, attribute: .left, multiplier: 1, constant: 0).withPriority(op))
            }
        }
        
        if axes.isVertical {
            s.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: s, attribute: .centerY, multiplier: 1, constant: 0).withPriority(priority))
            
            if let op = avoidingOverflow {
                s.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: s, attribute: .top, multiplier: 1, constant: 0).withPriority(op))
            }
        }
        
        return self
    }
    
    @discardableResult
    public func addAndCenterIn(_ superview: UIView, _ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required, avoidingOverflow: UILayoutPriority? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        return centeredInSuperview(axes, priority: priority, avoidingOverflow: avoidingOverflow)
    }
}

// Pinning in a view

extension UIView {
    // Returns the superview
    @discardableResult
    public func addedTo<T: UIView>(_ superview: T, _ pins: Pin...) -> T {
        self.addTo(superview, pins)
        return superview
    }
    
    // Returns self
    @discardableResult
    public func addTo(_ superview: UIView, _ pins: Pin...) -> Self {
        return self.addTo(superview, pins)
    }
    
    // Returns self
    @discardableResult
    public func addTo(_ superview: UIView, _ pins: [Pin]) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        
        NSLayoutConstraint.activate(pins.flatMap { pin in pin.attributes.compactMap { attr -> NSLayoutConstraint? in
            switch (attr, pin.relation) {
                case (.leading, .equal):
                    return leadingAnchor.constraint(equalTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
                case (.leading, .greaterThanOrEqual):
                    return leadingAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
                case (.leading, .lessThanOrEqual):
                    return leadingAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
                    
                case (.trailing, .equal):
                    return trailingAnchor.constraint(equalTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
                case (.trailing, .greaterThanOrEqual):
                    return trailingAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
                case (.trailing, .lessThanOrEqual):
                    return trailingAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
                    
                case (.top, .equal):
                    return topAnchor.constraint(equalTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
                case (.top, .greaterThanOrEqual):
                    return topAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
                case (.top, .lessThanOrEqual):
                    return topAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
                    
                case (.bottom, .equal):
                    return bottomAnchor.constraint(equalTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
                case (.bottom, .greaterThanOrEqual):
                    return bottomAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
                case (.bottom, .lessThanOrEqual):
                    return bottomAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
                    
                case (.centerX, .equal):
                    return centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: pin.constant).withPriority(pin.priority)
                    
                case (.centerY, .equal):
                    return centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: pin.constant).withPriority(pin.priority)
                    
                default:
                    return nil
            }
        }})
        
        return self
    }
}


// Margins for subviews of UIStackView
extension UIView {
    public func setCustomSpacingBefore(_ spacing: CGFloat) {
        guard let stack = superview as? UIStackView,
              let myIndex = stack.arrangedSubviews.firstIndex(of: self),
              myIndex > 0
        else { return }
        
        stack.setCustomSpacing(spacing, after: stack.arrangedSubviews[myIndex - 1])
    }
    
    public func setCustomSpacingAfter(_ spacing: CGFloat) {
        guard let stack = superview as? UIStackView else { return }
        stack.setCustomSpacing(spacing, after: self)
    }
}

public enum PinType {
    case safe
    case margin
    case readable
    case absolute
    
    func guide(for view: UIView) -> UILayoutGuide? {
        switch self {
            case .safe: return view.safeAreaLayoutGuide
            case .margin: return view.layoutMarginsGuide
            case .readable: return view.readableContentGuide
            default: return nil
        }
    }
}

public struct Pin {
    public let attributes: NSLayoutConstraint.Attributes
    public let type: PinType
    public let constant: CGFloat
    public let relation: NSLayoutConstraint.Relation
    public let priority: UILayoutPriority?
    
    public init(_ attributes: NSLayoutConstraint.Attributes, to type: PinType = .safe, _ relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = 0, priority: UILayoutPriority? = nil) {
        self.attributes = attributes
        self.type = type
        self.relation = relation
        self.constant = constant
        self.priority = priority
    }
}

// Making dimensions equal

extension Array where Element: UIView {
    @discardableResult
    public func equal(_ sides: NSLayoutConstraint.Attributes) -> [Element] {
        guard let first = first else { return self }
        for item in suffix(from: 1) {
            for j in sides {
                NSLayoutConstraint(item: item, attribute: j, relatedBy: .equal, toItem: first, attribute: j, multiplier: 1, constant: 0).isActive = true
            }
        }
        return self
    }
    
    @discardableResult
    public func space(_ axis: NSLayoutConstraint.Axis, relation: NSLayoutConstraint.Relation = .equal, _ constant: CGFloat = λ) -> [Element] {
        for i in 0..<(count-1) {
            let one = self[i]
            let two = self[i+1]
            
            if axis == .horizontal {
                switch relation {
                    case .equal: two.leadingAnchor.constraint(equalTo: one.trailingAnchor, constant: constant).isActive = true
                    case .greaterThanOrEqual: two.leadingAnchor.constraint(greaterThanOrEqualTo: one.trailingAnchor, constant: constant).isActive = true
                    case .lessThanOrEqual: two.leadingAnchor.constraint(lessThanOrEqualTo: one.trailingAnchor, constant: constant).isActive = true
                    @unknown default: break
                }
            }
            else {
                switch relation {
                    case .equal: two.topAnchor.constraint(equalTo: one.bottomAnchor, constant: constant).isActive = true
                    case .greaterThanOrEqual: two.topAnchor.constraint(greaterThanOrEqualTo: one.bottomAnchor, constant: constant).isActive = true
                    case .lessThanOrEqual: two.topAnchor.constraint(lessThanOrEqualTo: one.bottomAnchor, constant: constant).isActive = true
                    @unknown default: break
                }
            }
        }
        return self
    }
}
