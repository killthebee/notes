import UIKit

class TopBannerSubCell: UICollectionViewCell {
    
    static let cellIdentifier = "TopBannerSubCellIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
