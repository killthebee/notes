import UIKit

class YearHeaderCell: UICollectionReusableView {
    
    static let cellIdentifier = "YearHeaderCellIdentifier"
    
    var cellData: String? {
        didSet {
            yearLable.text = cellData ?? "2024"
        }}
    
    let yearLable: UILabel = {
        let lable = UILabel()
        lable.text = "2024"
        lable.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lable.textColor = .white
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = backgroundColor
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
