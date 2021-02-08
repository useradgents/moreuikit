import UIKit

public class UAFlowView: UIControl {
    
    @IBInspectable public var interitemSpacing: CGFloat = 8 { didSet { setNeedsLayout() }}
    @IBInspectable public var lineSpacing: CGFloat = 8 { didSet { setNeedsLayout() }}
    @IBInspectable public var alignment: NSTextAlignment = .left { didSet { setNeedsLayout() }}
    
    public override var intrinsicContentSize: CGSize { get {
        if let lastSubView = self.subviews.last {
            return CGSize(width: bounds.size.width, height: lastSubView.frame.maxY)
        } else {
            return CGSize(width: bounds.size.width, height: 44)
        }
    }}
    
    public override func layoutSubviews() {
        var lines: [[UIView]] = [[]]
        
        var lastOrigin: CGPoint = .zero
        subviews.forEach { subview in
            subview.transform = .identity
            let intrinsicContentSize = subview.intrinsicContentSize
            
            let availableWidth = (self.frame.maxX - self.frame.minX)
            
            let size = CGSize(width: min(intrinsicContentSize.width, availableWidth),
                              height: intrinsicContentSize.height)
            
            var frame = CGRect(origin: lastOrigin, size: size)
            
            if frame.maxX > bounds.size.width {
                lastOrigin = CGPoint(x: 0, y: lines.last!.enclosingRect.maxY + lineSpacing)
                frame = CGRect(origin: lastOrigin, size: size)
                lines.append([])
            }
            
            var last = lines.removeLast()
            last.append(subview)
            lines.append(last)
            
            subview.frame = frame
            lastOrigin = CGPoint(x: frame.maxX + interitemSpacing, y: frame.minY)
        }
        
        if alignment == .right || alignment == .center {
            lines.forEach { line in
                let enclosing = line.enclosingRect
                let Δ = (bounds.width - enclosing.width) / (alignment == .center ? 2 : 1)
                
                line.forEach({ view in
                    view.transform = CGAffineTransform(translationX: Δ, y: 0)
                })
            }
        }
        self.invalidateIntrinsicContentSize()
    }
    
}
