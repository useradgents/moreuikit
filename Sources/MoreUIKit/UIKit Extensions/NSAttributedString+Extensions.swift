import UIKit

extension NSAttributedString {
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = width × .greatestFiniteMagnitude
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = .greatestFiniteMagnitude × height
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSMutableAttributedString {
    public func append(_ s: String) {
        append(NSAttributedString(string: s))
    }
}

extension NSParagraphStyle {
    public static var centered: NSParagraphStyle {
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        return p
    }
}

extension UIImage {
    public var asAttributedString: NSAttributedString {
        return NSAttributedString(attachment: NSTextAttachmentOffset(image: self))
    }
    
    public func asAttributedString(baselineOffset offset: CGFloat = 0) -> NSAttributedString {
        return NSAttributedString(attachment: NSTextAttachmentOffset(image: self, baselineOffset: offset))
    }
}

public class NSTextAttachmentOffset: NSTextAttachment {
    public var offset: CGFloat
    
    public init(image: UIImage, baselineOffset offset: CGFloat = 0) {
        self.offset = offset
        super.init(data: nil, ofType: nil)
        self.image = image
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.offset = 0
        super.init(coder: aDecoder)
    }
    
    public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return CGRect(x: 0, y: offset, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
    }
}

