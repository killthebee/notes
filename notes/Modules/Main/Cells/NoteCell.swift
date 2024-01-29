import UIKit

class NoteCell: UICollectionViewCell {
    
    static let cellIdentifier = "NotCellIdentifier"
    
    private let dateLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 12)
        let attributedDate = NSMutableAttributedString(string: "23 january")
        let dateRange = NSMakeRange(0, 2)
        attributedDate.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: 15,
                weight: .bold
            ),
            NSAttributedString.Key.foregroundColor: dateColor],
            range: dateRange
        )
        lable.attributedText = attributedDate
        
        return lable
    }()
    
    private let headerLable: UILabel = {
        let lable = UILabel()
        lable.text = "Note Header!"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return lable
    }()
    
    private let noteTextLable: UILabel = {
        let lable = UILabel()
        lable.text = "Here is some of my notes"
        lable.textColor = .white
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureCell()
        disableAutoresizing()
        addSubviews()
        setUpConstrains()
    }
    
    private func configureCell() {
        backgroundColor = cellsBackgroundColor
        layer.cornerRadius = 5
    }
    
    private func disableAutoresizing() {
        [dateLable, headerLable, noteTextLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [dateLable, headerLable, noteTextLable
        ].forEach{addSubview($0)}
    }
    
    private func setUpConstrains(){
        let leftInset: CGFloat = 16
        let constraints: [NSLayoutConstraint] = [
            dateLable.topAnchor.constraint(equalTo: topAnchor),
            dateLable.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: leftInset
            ),
            dateLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLable.heightAnchor.constraint(equalToConstant: 30),
            
            headerLable.topAnchor.constraint(
                equalTo: dateLable.bottomAnchor
            ),
            headerLable.leadingAnchor.constraint(
                equalTo: dateLable.leadingAnchor
            ),
            headerLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLable.heightAnchor.constraint(equalToConstant: 20),
            
            noteTextLable.topAnchor.constraint(
                equalTo: headerLable.bottomAnchor
            ),
            noteTextLable.leadingAnchor.constraint(
                equalTo: headerLable.leadingAnchor
            ),
            noteTextLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            noteTextLable.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
