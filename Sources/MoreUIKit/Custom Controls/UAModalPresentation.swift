import UIKit

/**
 Animated transition for presenting modal view controllers,
 with their presenting view controller still visible underneath a transparent black veil.
 
 Usage in an arbitrary view controller:
 
 ~~~
    class MyViewController: UIViewController, UIViewControllerTransitioningDelegate {
 
        override init(...) {
            //...
            modalPresentationStyle = .custom
            transitioningDelegate = self
        }
 
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            UAModalPresenter()
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            UAModalDismisser()
        }
    }
 ~~~
 
 - Remark: See also `UAModalDismisser` for dismissing.
 */

public final class UAModalPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    let veilOpacity: CGFloat
    let transition: Transition
    
    public enum Transition {
        case slideIn
        case appear
    }
    
    /**
     - Parameters:
        - veilOpacity: Opacity of the veil obscuring the presenting view controller. The veil is always black. (Default: 0.5)
        - transition:
            - `.slideIn`: appears from below, with a slide-in animation. (Default value)
            - `.appear`: fade in and grow from the center of the screen.
     */
    public init(veilOpacity: CGFloat = 0.5, transition: Transition = .slideIn) {
        self.veilOpacity = veilOpacity
        self.transition = transition
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let modal = transitionContext.viewController(forKey: .to) else { return }
        
        let veil = UIView()
        veil.translatesAutoresizingMaskIntoConstraints = false
        veil.backgroundColor = UIColor.black.withAlphaComponent(veilOpacity)
        
        modal.view.layer.cornerRadius = 24
        modal.view.layer.masksToBounds = true
        modal.view.translatesAutoresizingMaskIntoConstraints = false
        
        transitionContext.containerView.addSubview(veil)
        transitionContext.containerView.addSubview(modal.view)
        
        transitionContext.containerView.addConstraints([
            veil.topAnchor.constraint(equalTo: transitionContext.containerView.topAnchor),
            veil.bottomAnchor.constraint(equalTo: transitionContext.containerView.bottomAnchor),
            veil.leadingAnchor.constraint(equalTo: transitionContext.containerView.leadingAnchor),
            veil.trailingAnchor.constraint(equalTo: transitionContext.containerView.trailingAnchor),
            
            modal.view.centerYAnchor.constraint(equalTo: transitionContext.containerView.centerYAnchor),
            modal.view.topAnchor.constraint(greaterThanOrEqualTo: transitionContext.containerView.readableContentGuide.topAnchor),
            modal.view.topAnchor.constraint(greaterThanOrEqualTo: transitionContext.containerView.safeAreaLayoutGuide.topAnchor),
            modal.view.leadingAnchor.constraint(equalTo: transitionContext.containerView.readableContentGuide.leadingAnchor),
            modal.view.trailingAnchor.constraint(equalTo: transitionContext.containerView.readableContentGuide.trailingAnchor)
        ])
        
        if modal.preferredContentSize.width > 0 {
            transitionContext.containerView.addConstraints([
                modal.view.widthAnchor.constraint(lessThanOrEqualToConstant: modal.preferredContentSize.width)
            ])
        }
        
        if modal.preferredContentSize.height > 0 {
            transitionContext.containerView.addConstraints([
                modal.view.heightAnchor.constraint(lessThanOrEqualToConstant: modal.preferredContentSize.height)
            ])
        }
        
        transitionContext.containerView.setNeedsLayout()
        transitionContext.containerView.layoutIfNeeded()
        
        
        switch transition {
            case .slideIn:
                veil.alpha = 0
                modal.view.transform = CGAffineTransform(translationX: 0, y: transitionContext.containerView.bounds.height - modal.view.frame.minY)
                
            case .appear:
                veil.alpha = 0
                modal.view.alpha = 0
                modal.view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut], animations: {
            veil.alpha = 1
            modal.view.alpha = 1
            modal.view.transform = .identity
        }) { (done) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

/**
 Animated transition for dismissing modal view controllers presented with `UAModalPresenter`.
 
 - Remark: See also `UAModalPresenter` for more information.
 */

public final class UAModalDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    let transition: Transition
    
    public enum Transition {
        case slideOut
        case disappear
    }
    
    /**
     - Parameters:
         - transition:
           - `.slideOut` is the reciprocal transition to `.slideIn` (Default value)
           - `.disappear` is the reciprocal transition to `.appear`.
     
     */
    public init(transition: Transition = .slideOut) {
        self.transition = transition
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.containerView.subviews.count == 2 else { return }
        let veil = transitionContext.containerView.subviews[0]
        let modalView = transitionContext.containerView.subviews[1]
        
        let t = transition
        transitionContext.viewController(forKey: .to)?.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseIn], animations: {
            switch t {
                case .slideOut:
                    veil.alpha = 0
                    modalView.transform = CGAffineTransform(translationX: 0, y: transitionContext.containerView.bounds.height - modalView.frame.minY)
                    
                case .disappear:
                    veil.alpha = 0
                    modalView.alpha = 0
                    modalView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }
            
        }) { (done) in
            transitionContext.viewController(forKey: .to)?.endAppearanceTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
