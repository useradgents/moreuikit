import UIKit

extension UITableView {
    public func autolayoutTableHeaderFooterViews() {
        autolayoutTableHeaderView()
        autolayoutTableFooterView()
    }
    
    public func autolayoutTableHeaderView() {
        guard let headerView = tableHeaderView else { return }
        let w = bounds.width
        let h = headerView.systemLayoutSizeFitting(CGSize(width: w, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        var f = headerView.frame
        if h != f.height {
            f.size.height = h
            headerView.frame = f
            tableHeaderView = headerView
        }
    }
    
    public func autolayoutTableFooterView() {
        guard let footerView = tableFooterView else { return }
        let w = bounds.width
        let h = footerView.systemLayoutSizeFitting(CGSize(width: w, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        var f = footerView.frame
        if h != f.height {
            f.size.height = h
            footerView.frame = f
            tableFooterView = footerView
        }
    }
}

/// UITableView subclass with intrinsic height calculated from its content
/// Obviously, only use this for "small" tables, where scrolling is not used.
public class UAAutoHeightTableView: UITableView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }

    public override var intrinsicContentSize: CGSize {
        get {
            var height:CGFloat = 0;
            if let h = tableHeaderView {
                height += h.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            }
            for s in 0..<self.numberOfSections {
                let nRowsSection = self.numberOfRows(inSection: s)
                for r in 0..<nRowsSection {
                    height += self.rectForRow(at: IndexPath(row: r, section: s)).size.height;
                }
            }
            if let f = tableFooterView {
                height += f.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            }
            return CGSize(width: -1, height: height)
        }
        set {
        }
    }
}

public extension IndexPath {
    var tuple: (Int, Int) { (section, row) }
}

public extension UITableViewCell {
    static let defaultHeight: CGFloat = 43
}

public class UATableViewContainerCell: UITableViewCell {
    public weak var controller: UIViewController?
    var spacer: UIView
    var heightConstraint: NSLayoutConstraint
    
    public init(height: CGFloat) {
        spacer = UIView(frame: .zero)
        heightConstraint = spacer.heightAnchor.constraint(equalToConstant: height)
        super.init(style: .default, reuseIdentifier: "UATableViewContainerCell")
        
        spacer.addTo(contentView, Pin(.all, to: .absolute))
        heightConstraint.isActive = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override func prepareForReuse() {
        if let c = controller {
            c.willMove(toParent: nil)
            c.removeFromParent()
            c.view.removeFromSuperview()
            controller = nil
        }
    }
}

extension UIViewController {
    public func containedInTableViewCell(in parent: UIViewController) -> UATableViewContainerCell {
        let cell = UATableViewContainerCell(height: preferredContentSize.height)
        cell.controller = self
        parent.addChild(self)
        view.addTo(cell, Pin(.all, to: .absolute))
        didMove(toParent: parent)
        return cell
    }
}
