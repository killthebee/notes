import UIKit

class PasswordViewController: UIViewController, PasswordViewProtocol {
    
    var presenter: PasswordPresenterProtocol?
    
    var numsIput: String = ""
    let numPadSymbols: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "<"]
    ]
    
    func addDot() {
        let dot = makeDot()
        dotsStackView.addArrangedSubview(dot)
    }
    
    func removeDot() {
        let dot = dotsStackView.arrangedSubviews[0]
        dotsStackView.removeOneArrangedSubview()
    }
    
    private func makeDot() -> UIImageView {
        let view = UIImageView(image: UIImage(named: "dot"))
        view.contentMode = .scaleAspectFit
        
        return view
    }
    
    private let buttomTextLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = "create 4 digit password"
        lable.textColor = buttonColor
        
        return lable
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout.init()
        )
        collectionView.register(
            NumCell.self,
            forCellWithReuseIdentifier: NumCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = buttonColor
        collectionView.layer.cornerRadius = 20
        return collectionView
    }()
    
    private let dotsStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = buttonColor
        stack.layer.cornerRadius = 20
        stack.axis = .horizontal
        stack.isUserInteractionEnabled = false
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = mainBackgroundColor
        addSubviews()
        disableAutoresizing()
        setUpConstrains()
        configureCompositionalLayout()
    }
    
    private func addSubviews() {
        [dotsStackView, buttomTextLable, collectionView
        ].forEach{view.addSubview($0)}
    }
    
    private func disableAutoresizing() {
        [dotsStackView, buttomTextLable, collectionView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    func setUpConstrains() {
        let spacing: CGFloat = 16
        let constraints: [NSLayoutConstraint] = [
            dotsStackView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: view.bounds.height * 0.2
            ),
            dotsStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: spacing
            ),
            dotsStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * spacing
            ),
            dotsStackView.heightAnchor.constraint(equalToConstant: 62),
            
            collectionView.topAnchor.constraint(
                equalTo: dotsStackView.bottomAnchor,
                constant: 30
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: spacing
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * spacing
            ),
            collectionView.heightAnchor.constraint(equalToConstant: 400),

            buttomTextLable.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: 30
            ),
            buttomTextLable.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: spacing
            ),
            buttomTextLable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * spacing
            ),
            buttomTextLable.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension PasswordViewController {
    
    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            return PasswordVCLayouts.shared.numsLayouts()
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
