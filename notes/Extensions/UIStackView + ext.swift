import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce(
            []
        ) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(
            removedSubviews.flatMap({ $0.constraints })
        )
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func removeOneArrangedSubview() {
        guard arrangedSubviews.count > 0 else { return }
        let removedSubview = arrangedSubviews[0]
        NSLayoutConstraint.deactivate(removedSubview.constraints)
        removedSubview.removeFromSuperview()
    }
}
