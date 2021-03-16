import UIKit

/**
 Placeholder view that shows its bounds and margins over a nice blueprint design.
 */

public final class UABlueprintView: UIView {
    public override var bounds: CGRect { didSet { setNeedsDisplay() }}
    public override func safeAreaInsetsDidChange() {
        setNeedsDisplay()
    }
    public override func layoutMarginsDidChange() {
        setNeedsDisplay()
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let bg = UIColor(red:0.13, green:0.56, blue:0.83, alpha:1.00)
        let fg = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.00)
        
        ctx.setFillColor(bg.cgColor)
        ctx.fill(rect)
        
        let b = bounds.inset(by: layoutMargins)
        
        ctx.setStrokeColor(fg.cgColor)
        ctx.setLineWidth(1)
        ctx.stroke(b)
        
        ctx.setLineWidth(0.5)
        ctx.strokeLineSegments(between: [
            CGPoint(x: b.minX, y: b.minY),
            CGPoint(x: b.maxX, y: b.maxY),
            CGPoint(x: b.minX, y: b.maxY),
            CGPoint(x: b.maxX, y: b.minY)
        ])
        
        ctx.setLineWidth(0.2)
        var z: CGFloat = 0
        while z < max(b.maxX - b.minX, b.maxY - b.minY) {
            z += 8
            if b.minY + z < b.maxY {
                ctx.move(to: CGPoint(x: b.minX, y: b.minY + z))
                ctx.addLine(to: CGPoint(x: b.maxX, y: b.minY + z))
                
            }
            if b.minX + z < b.maxX {
                ctx.move(to: CGPoint(x: b.minX + z, y: b.minY))
                ctx.addLine(to: CGPoint(x: b.minX + z, y: b.maxY))
            }
        }
        ctx.strokePath()
        
        ctx.setLineWidth(0.35)
        z = 0
        while z < max(b.maxX - b.minX, b.maxY - b.minY) {
            z += 32
            if b.minY + z < b.maxY {
                ctx.move(to: CGPoint(x: b.minX, y: b.minY + z))
                ctx.addLine(to: CGPoint(x: b.maxX, y: b.minY + z))
                
            }
            if b.minX + z < b.maxX {
                ctx.move(to: CGPoint(x: b.minX + z, y: b.minY))
                ctx.addLine(to: CGPoint(x: b.minX + z, y: b.maxY))
            }
        }
        ctx.strokePath()
        
        let dim = "ᴏᴜᴛᴇʀ\n\(fracFormat(bounds.width)) × \(fracFormat(bounds.height))\nɪɴɴᴇʀ\n\(fracFormat(bounds.width - layoutMargins.left - layoutMargins.right)) × \(fracFormat(bounds.height - layoutMargins.top - layoutMargins.bottom))"
        let ps = NSMutableParagraphStyle()
        ps.alignment = .center
        let attr = NSAttributedString(string: dim, attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: fg, .paragraphStyle: ps])
        let size = attr.size()
        
        let x = b.midX - size.width / 2
        let y = b.midY - size.height / 2
        
        let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
        let orect = rect.insetBy(dx: -8, dy: -8)
        
        let path = UIBezierPath(roundedRect: orect, cornerRadius: min(8, min(orect.height, orect.width) / 2))
        path.lineWidth = 0.5
        path.fill()
        path.stroke()
        
        attr.draw(in: rect)
        
        if layoutMargins.top > 0 {
            let astr = NSAttributedString(string: fracFormat(layoutMargins.top), attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: fg])
            let size = astr.size()
            let x = b.midX - size.width / 2
            let y = max(0, layoutMargins.top / 2 - size.height / 2)
            
            let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            ctx.setStrokeColor(fg.cgColor)
            ctx.setLineWidth(0.5)
            ctx.setLineDash(phase: 4, lengths: [2, 2])
            ctx.strokeLineSegments(between: [CGPoint(x: rect.midX, y: 0), CGPoint(x: rect.midX, y: layoutMargins.top)])
            
            let orect = rect.insetBy(dx: -2, dy: -2)
            ctx.setFillColor(bg.cgColor)
            ctx.fill(orect)
            astr.draw(at: CGPoint(x: x, y: y))
        }
        
        if layoutMargins.left > 0 {
            let astr = NSAttributedString(string: fracFormat(layoutMargins.left), attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: fg])
            let size = astr.size()
            let x = max(0, layoutMargins.left / 2 - size.width / 2)
            let y = b.midY - size.height / 2
            
            let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            ctx.setStrokeColor(fg.cgColor)
            ctx.setLineWidth(0.5)
            ctx.setLineDash(phase: 4, lengths: [2, 2])
            ctx.strokeLineSegments(between: [CGPoint(x: 0, y: rect.midY), CGPoint(x: layoutMargins.left, y: rect.midY)])
            
            let orect = rect.insetBy(dx: -2, dy: -2)
            ctx.setFillColor(bg.cgColor)
            ctx.fill(orect)
            astr.draw(at: CGPoint(x: x, y: y))
        }
        
        if layoutMargins.bottom > 0 {
            let astr = NSAttributedString(string: fracFormat(layoutMargins.bottom), attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: fg])
            let size = astr.size()
            let x = b.midX - size.width / 2
            let y = bounds.maxY - max(0, layoutMargins.bottom / 2 - size.height / 2)
            
            let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            ctx.setStrokeColor(fg.cgColor)
            ctx.setLineWidth(0.5)
            ctx.setLineDash(phase: 4, lengths: [2, 2])
            ctx.strokeLineSegments(between: [CGPoint(x: rect.midX, y: bounds.maxY), CGPoint(x: rect.midX, y: bounds.maxY - layoutMargins.bottom)])
            
            let orect = rect.insetBy(dx: -2, dy: -2)
            ctx.setFillColor(bg.cgColor)
            ctx.fill(orect)
            astr.draw(at: CGPoint(x: x, y: y))
        }
        
        if layoutMargins.right > 0 {
            let astr = NSAttributedString(string: fracFormat(layoutMargins.right), attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: fg])
            let size = astr.size()
            let x = bounds.maxX - max(0, layoutMargins.right / 2 - size.width / 2)
            let y = b.midY - size.height / 2
            
            let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            ctx.setStrokeColor(fg.cgColor)
            ctx.setLineWidth(0.5)
            ctx.setLineDash(phase: 4, lengths: [2, 2])
            ctx.strokeLineSegments(between: [CGPoint(x: bounds.maxX, y: rect.midY), CGPoint(x: bounds.maxX - layoutMargins.right, y: rect.midY)])
            
            let orect = rect.insetBy(dx: -2, dy: -2)
            ctx.setFillColor(bg.cgColor)
            ctx.fill(orect)
            astr.draw(at: CGPoint(x: x, y: y))
        }
        
        
    }
    
    func fracFormat(_ value: CGFloat) -> String {
        let val = abs(value)
        let neg = (val != value)
        let flt = val.truncatingRemainder(dividingBy: 1)
        let int = Int(val - flt)
        
        if flt < 0.01 {
            return "\(neg ? "-" : "")\(int)"
        }
        
        for den in 2...10 {
            let anum = flt * CGFloat(den)
            let num = round(anum)
            
            if abs(anum - num) < 0.01 {
                if int == 0 {
                    return "\(fraction(numerator: Int(neg ? -num : num), denominator: Int(den)))"
                }
                else {
                    return "\(neg ? "-" : "")\(int)\(fraction(numerator: Int(num), denominator: Int(den)))"
                }
            }
        }
        
        return "[FAIL] \(value)"
    }
    
    func fraction(numerator: Int, denominator: Int) -> String {
        return String(numerator).map({
            if $0 == Character("-") { return "⁻" }
            if $0 == Character("1") { return "¹" }
            if $0 == Character("2") { return "²" }
            if $0 == Character("3") { return "³" }
            if (Character("0")...Character("9")).contains($0) {
                return Character(Unicode.Scalar($0.unicodeScalars.first!.value - 0x0030 + 0x2070)!)
            }
            return $0
        }) + "⁄" + String(denominator).map({
            if (Character("0")...Character("9")).contains($0) {
                return Character(Unicode.Scalar($0.unicodeScalars.first!.value - 0x0030 + 0x2080)!)
            }
            return $0
        })
    }
}
