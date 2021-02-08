import CoreGraphics
import UIKit

public extension CGPoint {
    func offset(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        CGPoint(x: self.x + x, y: self.y + y)
    }
    
    func dotProduct(with other: CGPoint) -> CGFloat {
        self.x * other.x + self.y * other.y
    }
    
    var length: CGFloat { sqrt(dotProduct(with: self)) }
    
    func adding(_ other: CGPoint) -> CGPoint {
        CGPoint(x: self.x + other.x, y: self.y + other.y)
    }
    
    func substracting(_ other: CGPoint) -> CGPoint {
        CGPoint(x: self.x - other.x, y: self.y - other.y)
    }
    
    func multiplied(by value: CGFloat) -> CGPoint {
        CGPoint(x: value * self.x, y: value * self.y)
    }
}

