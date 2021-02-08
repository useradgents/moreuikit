import UIKit.UIFont

public extension UIFont {
    static func universal(name: String, size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: style).scaledFont(for: UIFont(name: name, size: size)!)
    }
}
