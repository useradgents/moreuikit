import UIKit

extension UIView {
    public enum Animation {
        // For use on cells
        case tapUnavailable
        case pressAndHold
        case release
        case pressOrRelease(Bool)
    }
    
    public func animate(_ animation: Animation, plus: (() -> Void)? = nil, then: ((Bool) -> Void)? = nil) {
        switch animation {
            case .tapUnavailable:
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = .init(scaleX: 0.98, y: 0.98)
                }) { _ in
                    UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseIn, animations: {
                        self.transform = .identity
                    }, completion: then)
                }
                
            case .pressAndHold:
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    plus?()
                }, completion: then)
                
            case .release:
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    plus?()
                }, completion: then)
                
            case .pressOrRelease(let b):
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = b ? .init(scaleX: 0.9, y: 0.9) : .identity
                    plus?()
                }, completion: then)
                
        }
    }
}

