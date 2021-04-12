import UIKit

public extension UIViewController {
    func inNavigationController(navigationBarClass: AnyClass? = nil, prefersLargeTitle: Bool = true, toolbarClass: AnyClass? = nil) -> UINavigationController {
        let nc = UINavigationController(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        nc.navigationBar.prefersLargeTitles = prefersLargeTitle
        nc.viewControllers = [self]
        return nc
    }
    
    @discardableResult
    func withModalPresentationStyle(_ mps: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = mps
        return self
    }
    
    @discardableResult
    func withTabBarItem(title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) -> Self {
        tabBarItem.title = title
        tabBarItem.image = image
        tabBarItem.selectedImage = selectedImage
        return self
    }
    
    @discardableResult
    func withNavigationItem(title: String? = nil, left: [UIBarButtonItem]? = nil, right: [UIBarButtonItem]? = nil) -> Self {
        navigationItem.title = title
        navigationItem.leftBarButtonItems = left
        navigationItem.rightBarButtonItems = right
        return self
    }
    
    @discardableResult
    func withDoneButton(_ target: Any?, _ action: Selector?) -> Self {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        return self
    }
    
    func firstParent<T>(ofKind kind: T.Type) -> T? {
        let nearest = parent ?? navigationController ?? tabBarController ?? presentingViewController
        return (nearest as? T) ?? nearest?.firstParent(ofKind: T.self)
    }
    
    static func dummy(title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) -> UIViewController {
        let instance = UIViewController(nibName: nil, bundle: nil)
        if #available(iOS 13.0, *) {
            instance.view.backgroundColor = .systemBackground
        } else {
            instance.view.backgroundColor = .white
        }
        instance.navigationItem.title = title
        instance.tabBarItem.title = title
        instance.tabBarItem.image = image
        instance.tabBarItem.selectedImage = selectedImage
        return instance
    }
}

public extension UINavigationController {
    convenience init(title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        self.init()
        tabBarItem.title = title
        tabBarItem.image = image
        tabBarItem.selectedImage = selectedImage
    }
}

