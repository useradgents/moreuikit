import UIKit

extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        ceil(self.boundingRect(with: width × .greatestFiniteMagnitude, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height)
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        ceil(self.boundingRect(with: .greatestFiniteMagnitude × height, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).width)
    }
}
