import UIKit

class NumCell: UICollectionViewCell {
    
    static let identifier = "NumCellIdentifyer"
    var presenter: PasswordPresenterProtocol?
    var cellData: String? {
        didSet {
            numButton.setTitle(cellData, for: .normal)
        }
    }
    
    @objc
    func numButtonPressed(_ sender: UIButton) {
        sender.startAnimatingPressActions()
        presenter?.numPressed(num: sender.titleLabel?.text)
    }
    
    lazy var numButton: UIButton = {
        let numButton = UIButton()
        numButton.backgroundColor = .clear
        numButton.setTitleColor(dateColor, for: .normal)
        numButton.titleLabel?.font = UIFont.systemFont(ofSize: 62, weight: .bold)
        numButton.translatesAutoresizingMaskIntoConstraints = false
        numButton.addTarget(
            self,
            action: #selector(numButtonPressed),
            for: .touchDown
        )
        numButton.startAnimatingPressActions()
        
        return numButton
    }()
    
    let coverView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coverView)
        coverView.addSubview(numButton)
        let constraints: [NSLayoutConstraint] = [
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            numButton.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            numButton.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
