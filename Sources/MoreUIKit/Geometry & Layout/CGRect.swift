import UIKit

public extension CGRect {
    var northWest: CGPoint { CGPoint(x: minX, y: minY) }
    var north: CGPoint     { CGPoint(x: midX, y: minY) }
    var northEast: CGPoint { CGPoint(x: maxX, y: minY) }
    var west: CGPoint      { CGPoint(x: minX, y: midY) }
    var center: CGPoint    { CGPoint(x: midX, y: midY) }
    var east: CGPoint      { CGPoint(x: maxX, y: midY) }
    var southWest: CGPoint { CGPoint(x: minX, y: maxY) }
    var south: CGPoint     { CGPoint(x: midX, y: maxY) }
    var southEast: CGPoint { CGPoint(x: maxX, y: maxY) }
    
    func insetBy(_ insets: UIEdgeInsets) -> CGRect {
        CGRect(x: minX + insets.left, y: minY + insets.top, width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }
    
    func insetBy(t: CGFloat = 0, l: CGFloat = 0, r: CGFloat = 0, b: CGFloat = 0) -> CGRect {
        CGRect(x: minX + l, y: minY + t, width: width - l - r, height: height - t - b)
    }
    
    func hairline(on side: UIRectSide, for screen: UIScreen = .main) -> CGRect {
        let hairline = screen.hairline
        switch side {
            case .top:
                return CGRect(x: minX, y: minY, width: width, height: hairline)
            case .left:
                return CGRect(x: minX, y: minY, width: hairline, height: height)
            case .bottom:
                return CGRect(x: minX, y: maxY - hairline, width: width, height: hairline)
            case .right:
                return CGRect(x: maxX - hairline, y: minY, width: hairline, height: height)
        }
    }
}

public extension Collection where Element == CGRect {
    var union:        CGRect { reduce(.null, { $0.union($1)        }) }
    var intersection: CGRect { reduce(.null, { $0.intersection($1) }) }
}
