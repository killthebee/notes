import UIKit

class NoteCell: UICollectionViewCell {
    
    static let cellIdentifier = "NotCellIdentifier"
    
    var cellData: Note? {
        didSet {
            guard let note = cellData else { return }
            
            imagesStackView.removeAllArrangedSubviews()
            for noteImageRelatedObject in note.images ?? [] {
                guard
                    let noteImage = noteImageRelatedObject as? NoteImage,
                    let imageData = noteImage.imageData
                else
                    { return }
                let newImage = UIImage(data: imageData, scale:1.0)?.resized(toHeight: 40)
                let imageView = UIImageView(image: newImage)
                imagesStackView.addArrangedSubview(imageView)
            }
            
            if let dateData = note.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateLable.text = dateFormatter.string(from: dateData)
            }
            
            if let header = note.header {
                headerLable.text = header
            }
            
            if let text = note.text {
                noteTextField.attributedText = text
            }
        }
    }
    
    private let dateLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 12)
        let attributedDate = NSMutableAttributedString(string: "31 feb 2025")
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
        lable.text = "Header's empty :("
        lable.textColor = dateColor
        lable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return lable
    }()
    
    private let noteTextField: UITextField = {
        let lable = UITextField()
        lable.text = "No text here:("
        lable.textColor = .white
        
        return lable
    }()
    
    private let imagesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        
        return stack
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
        [dateLable, headerLable, noteTextField, imagesStackView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [dateLable, headerLable, noteTextField, imagesStackView
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
            
            noteTextField.topAnchor.constraint(
                equalTo: headerLable.bottomAnchor
            ),
            noteTextField.leadingAnchor.constraint(
                equalTo: headerLable.leadingAnchor
            ),
            noteTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            noteTextField.heightAnchor.constraint(equalToConstant: 20),
            
            imagesStackView.topAnchor.constraint(
                equalTo: noteTextField.bottomAnchor,
                constant: 5
            ),
            imagesStackView.heightAnchor.constraint(equalToConstant: 40),
            imagesStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
