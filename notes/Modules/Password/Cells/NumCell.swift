import UIKit

class NumCell: UICollectionViewCell {
    
    static let identifier = "NumCellIdentifyer"
    var cellData: String? {
        didSet {
            numButton.setTitle(cellData, for: .normal)
        }
    }
    
    @objc
    func numButtonPressed(_ sender: UIButton) {
        sender.startAnimatingPressActions()
    }
    
    let numButton: UIButton = {
        let numButton = UIButton()
        numButton.backgroundColor = .clear
        numButton.setTitleColor(dateColor, for: .normal)
        numButton.titleLabel?.font = UIFont.systemFont(ofSize: 62, weight: .bold)
        numButton.translatesAutoresizingMaskIntoConstraints = false
        
        return numButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(numButton)
        let constraints: [NSLayoutConstraint] = [
            numButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            numButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            numButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
