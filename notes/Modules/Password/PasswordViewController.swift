import UIKit

class PasswordViewController: UIViewController, PasswordViewProtocol {
    
    var presenter: PasswordPresenterProtocol?
    
    private let buttomTextLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = "create 4 digit password"
        lable.textColor = buttonColor
        
        return lable
    }()
    
    private let numsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = buttonColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = buttonColor
        stack.layer.cornerRadius = 20
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for _ in 0 ..< 4 {
            let starView = UITextView()
            starView.text = "*"
            starView.textColor = dateColor
            starView.backgroundColor = .clear
            starView.isUserInteractionEnabled = false
            starView.showsVerticalScrollIndicator = false
            starView.sizeToFit()
            starView.textAlignment = .center
            starView.font = UIFont.systemFont(ofSize: 62, weight: .bold)
            stack.addArrangedSubview(starView)
        }
        
        return stack
    }()
    
    private let firstRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for num in 1 ... 3 {
            let numView = UITextView()
            numView.text = String(num)
            numView.textColor = dateColor
            numView.backgroundColor = .clear
            numView.isUserInteractionEnabled = false
            numView.showsVerticalScrollIndicator = false
            numView.sizeToFit()
            numView.textAlignment = .center
            numView.font = UIFont.systemFont(ofSize: 62, weight: .bold)
            stack.addArrangedSubview(numView)
        }
        
        return stack
    }()
    
    private let secondRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for num in 4 ... 6 {
            let numView = UITextView()
            numView.text = String(num)
            numView.textColor = dateColor
            numView.backgroundColor = .clear
            numView.isUserInteractionEnabled = false
            numView.showsVerticalScrollIndicator = false
            numView.sizeToFit()
            numView.textAlignment = .center
            numView.font = UIFont.systemFont(ofSize: 62, weight: .bold)
            stack.addArrangedSubview(numView)
        }
        
        return stack
    }()
    
    private let thirdRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for num in 7 ... 9 {
            let numView = UITextView()
            numView.text = String(num)
            numView.textColor = dateColor
            numView.backgroundColor = .clear
            numView.isUserInteractionEnabled = false
            numView.showsVerticalScrollIndicator = false
            numView.sizeToFit()
            numView.textAlignment = .center
            numView.font = UIFont.systemFont(ofSize: 62, weight: .bold)
            stack.addArrangedSubview(numView)
        }
        
        return stack
    }()
    
    private let fourthRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for symbol in [" ", "0", "<"] {
            let numView = UITextView()
            numView.text = symbol
            numView.textColor = dateColor
            numView.backgroundColor = .clear
            numView.isUserInteractionEnabled = false
            numView.showsVerticalScrollIndicator = false
            numView.sizeToFit()
            numView.textAlignment = .center
            numView.font = UIFont.systemFont(ofSize: 62, weight: .bold)
            stack.addArrangedSubview(numView)
        }
        
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
    }
    
    private func addSubviews() {
        [numsContainerView, starsStackView, buttomTextLable
        ].forEach{view.addSubview($0)}
        [firstRowStack, secondRowStack, thirdRowStack, fourthRowStack
        ].forEach{numsContainerView.addSubview($0)}
    }
    
    private func disableAutoresizing() {
        [numsContainerView, starsStackView, buttomTextLable,
         firstRowStack, secondRowStack, thirdRowStack, fourthRowStack
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    func setUpConstrains() {
        let spacing: CGFloat = 16
        let constraints: [NSLayoutConstraint] = [
            starsStackView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: view.bounds.height * 0.2
            ),
            starsStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: spacing
            ),
            starsStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * spacing
            ),
            starsStackView.heightAnchor.constraint(equalToConstant: 62),
            
            numsContainerView.topAnchor.constraint(
                equalTo: starsStackView.bottomAnchor,
                constant: 30
            ),
            numsContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: spacing
            ),
            numsContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * spacing
            ),
            numsContainerView.heightAnchor.constraint(equalToConstant: 400),
            
            buttomTextLable.topAnchor.constraint(
                equalTo: numsContainerView.bottomAnchor,
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
            
            firstRowStack.topAnchor.constraint(
                equalTo: numsContainerView.topAnchor,
                constant: spacing
            ),
            firstRowStack.leadingAnchor.constraint(
                equalTo: numsContainerView.leadingAnchor,
                constant: spacing
            ),
            firstRowStack.trailingAnchor.constraint(
                equalTo: numsContainerView.trailingAnchor,
                constant: -1 * spacing
            ),
            firstRowStack.heightAnchor.constraint(equalToConstant: 84),
            
            secondRowStack.topAnchor.constraint(
                equalTo: firstRowStack.bottomAnchor,
                constant: spacing
            ),
            secondRowStack.leadingAnchor.constraint(
                equalTo: numsContainerView.leadingAnchor,
                constant: spacing
            ),
            secondRowStack.trailingAnchor.constraint(
                equalTo: numsContainerView.trailingAnchor,
                constant: -1 * spacing
            ),
            secondRowStack.heightAnchor.constraint(equalToConstant: 84),
            
            thirdRowStack.topAnchor.constraint(
                equalTo: secondRowStack.bottomAnchor,
                constant: spacing
            ),
            thirdRowStack.leadingAnchor.constraint(
                equalTo: numsContainerView.leadingAnchor,
                constant: spacing
            ),
            thirdRowStack.trailingAnchor.constraint(
                equalTo: numsContainerView.trailingAnchor,
                constant: -1 * spacing
            ),
            thirdRowStack.heightAnchor.constraint(equalToConstant: 84),
            
            fourthRowStack.topAnchor.constraint(
                equalTo: thirdRowStack.bottomAnchor,
                constant: spacing
            ),
            fourthRowStack.leadingAnchor.constraint(
                equalTo: numsContainerView.leadingAnchor,
                constant: spacing
            ),
            fourthRowStack.trailingAnchor.constraint(
                equalTo: numsContainerView.trailingAnchor,
                constant: -1 * spacing
            ),
            fourthRowStack.heightAnchor.constraint(equalToConstant: 84),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
