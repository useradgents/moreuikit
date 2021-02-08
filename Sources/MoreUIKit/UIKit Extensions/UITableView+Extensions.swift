import UIKit

public extension UITableView {
    func autolayoutTableHeaderFooterViews() {
        autolayoutTableHeaderView()
        autolayoutTableFooterView()
    }
    
    func autolayoutTableHeaderView() {
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
    
    func autolayoutTableFooterView() {
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


