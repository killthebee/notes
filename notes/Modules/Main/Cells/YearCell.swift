import UIKit

class YearSubHeaderCell: UICollectionViewCell {
    
    static let cellIdentifier = "YearSubHeaderCellIdentifier"
    
    let yearLable: UILabel = {
        let lable = UILabel()
        lable.text = "2024"
        lable.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lable.textColor = .white
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(yearLable)
        yearLable.frame = bounds
    }
}
