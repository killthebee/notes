import UIKit

class NoteViewController: UIViewController, NoteViewProtocol {
    
    var presenter: NotePresenterProtocol?
    lazy var imagePicker = ImagePicker(
        presentationController: self,
        delegate: self
    )
    
    var isBoldOn = false
    var isItalicOn = false
    let possibleFonts: [String: UIFont] = [
        "regular": UIFont.systemFont(ofSize: 15, weight: .regular),
        "bold": UIFont.systemFont(ofSize: 15, weight: .bold),
        "italic": UIFont.italicSystemFont(ofSize: 15)
    ]
    
    var addedImages: [UIImage] = []
    
    @objc func dateDoneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func handleAddImageClicked(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @objc func dateCancelButtonTapped() {
        view.endEditing(true)
    }
    
    
    func setNewText(
        _ text: NSMutableAttributedString,
        range: NSRange,
        fontName: String
    ) {
        text.addAttribute(
            NSAttributedString.Key.font,
            value: possibleFonts[fontName]!,
            range: range
        )
        noteInputTextField.attributedText = text
    }
    
    @objc func boldChangeTapped(_ sender: UIButton) {
        isBoldOn = isBoldOn ? false : true
        sender.backgroundColor = isBoldOn ? .blue : .clear
        let fontName = presenter?.interactor?.getFontForBoldSwitch(
            isBoldOn
        ) ?? "regular"
        
        let targetFont = possibleFonts[fontName]
        noteInputTextField.typingAttributes?[
            NSAttributedString.Key.font
        ] = targetFont
        
        presenter?.interactor?.makeNewAtrText(
            noteInputTextField.attributedText,
            range: noteInputTextField.selectedRange,
            fontName: fontName
        )
    }
    
    @objc func italicChangeTapped(_ sender: UIButton) {
        isItalicOn = isItalicOn ? false : true
        sender.backgroundColor = isItalicOn ? .blue : .clear
        
        let fontName = presenter?.interactor?.getFontForItalicSwitch(
            isItalicOn
        ) ?? "regular"
        
        let targetFont = possibleFonts[fontName]
        noteInputTextField.typingAttributes?[
            NSAttributedString.Key.font
        ] = targetFont
        
        presenter?.interactor?.makeNewAtrText(
            noteInputTextField.attributedText,
            range: noteInputTextField.selectedRange,
            fontName: fontName
        )
    }
    
    let saveButton = NoteControlButton("SAVE")
    let deleteButton = NoteControlButton("DELETE")
    let exitButton = NoteControlButton("<")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private let topButtonsContainerView = UIView()
    
    private let editorButtonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = buttonColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = mainBackgroundColor.cgColor
        
        return view
    }()
    
    private let noteAreaContainer: UIView = {
        let view = UIView()
        view.backgroundColor = cellsBackgroundColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    private lazy var dateTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = cellsBackgroundColor
        field.layer.cornerRadius = 20
//        field.tag = 1
        field.inputView = datePicker
        field.textAlignment = .center
        field.textColor = dateColor
        
        return field
    }()
    
    private let noteInputTextField: InputTextField = {
        let field = InputTextField()
        field.backgroundColor = buttonColor
        field.layer.cornerRadius = 20
        field.contentVerticalAlignment = .top
        field.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        field.tag = 0
        
        return field
    }()
    
    private let imageLable: UILabel = {
        let lable = UILabel()
        lable.text = "add Images"
        lable.textColor = .white
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let noteTextLable: UILabel = {
        let lable = UILabel()
        lable.text = "add Text"
        lable.textColor = .white
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let imagesContainerView = UIView()
    
    private lazy var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.setImage(
            UIImage(named: "plusIcon60"),
            for: .normal
        )
        addImageButton.addTarget(
            self,
            action: #selector(handleAddImageClicked),
            for: .touchDown
        )
        
        return addImageButton
    }()
    
    private let imageStackCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = buttonColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let imagesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var boldButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bold60"), for: .normal)
        button.addTarget(
            self,
            action: #selector(boldChangeTapped),
            for: .touchDown
        )
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private lazy var italicButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "italic60"), for: .normal)
        button.addTarget(
            self,
            action: #selector(italicChangeTapped),
            for: .touchDown
        )
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private func configure() {
        view.backgroundColor = mainBackgroundColor
        addSubviews()
        disableAutoresizing()
        setUpConstrains()
        addToolbars()
        noteInputTextField.delegate = self
        // set date field to today for new entries
        dateDoneButtonTapped()
        addKeyboardNotifications()
    }
    
    private func addToolbars() {
        let doneDateButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(dateDoneButtonTapped)
        )
        let doneTextButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(dateDoneButtonTapped)
        )
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dateCancelButtonTapped)
        )

        dateTextField.inputAccessoryView = makeToolbar(
            barItems: [cancelButton, flexSpace, doneDateButton]
        )
        noteInputTextField.inputAccessoryView = makeToolbar(
            barItems: [flexSpace, doneTextButton]
        )
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -250
        editorButtonsBottomConstraint?.constant = -150
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
        editorButtonsBottomConstraint?.constant = -16
    }
    
    
    private func addSubviews() {
        [topButtonsContainerView,dateTextField, noteAreaContainer, editorButtonsContainerView
        ].forEach{view.addSubview($0)}
        [saveButton, deleteButton, exitButton
        ].forEach{topButtonsContainerView.addSubview($0)}
        [imageLable, noteTextLable, imagesContainerView, noteInputTextField
        ].forEach{noteAreaContainer.addSubview($0)}
        [imageStackCoverView, addImageButton,
        ].forEach{imagesContainerView.addSubview($0)}
        imageStackCoverView.addSubview(imagesStackView)
        [boldButton, italicButton
        ].forEach{editorButtonsContainerView.addSubview($0)}
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [topButtonsContainerView, editorButtonsContainerView, saveButton,
         deleteButton, exitButton, dateTextField, noteAreaContainer,
         imageLable, noteTextLable, imagesStackView, imagesContainerView,
         addImageButton, noteInputTextField, imageStackCoverView, boldButton,
         italicButton,
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private var editorButtonsBottomConstraint: NSLayoutConstraint?
    
    func setUpConstrains() {
        let edgeSpacing: CGFloat = 16
        editorButtonsBottomConstraint = editorButtonsContainerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -1 * edgeSpacing
        )
        guard
            let editorButtonsBottomConstraint = editorButtonsBottomConstraint
        else
            { return }
        
        let constraints: [NSLayoutConstraint] = [
            topButtonsContainerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            topButtonsContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: edgeSpacing
            ),
            topButtonsContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * edgeSpacing
            ),
            topButtonsContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(
                equalTo: topButtonsContainerView.topAnchor
            ),
            saveButton.bottomAnchor.constraint(
                equalTo: topButtonsContainerView.bottomAnchor
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: topButtonsContainerView.trailingAnchor
            ),
            saveButton.widthAnchor.constraint(
                equalToConstant: 100
            ),
            
            deleteButton.topAnchor.constraint(
                equalTo: topButtonsContainerView.topAnchor
            ),
            deleteButton.bottomAnchor.constraint(
                equalTo: topButtonsContainerView.bottomAnchor
            ),
            deleteButton.trailingAnchor.constraint(
                equalTo: saveButton.leadingAnchor,
                constant: -1 * edgeSpacing
            ),
            deleteButton.widthAnchor.constraint(
                equalToConstant: 100
            ),
            
            exitButton.topAnchor.constraint(
                equalTo: topButtonsContainerView.topAnchor
            ),
            exitButton.bottomAnchor.constraint(
                equalTo: topButtonsContainerView.bottomAnchor
            ),
            exitButton.leadingAnchor.constraint(
                equalTo: topButtonsContainerView.leadingAnchor,
                constant: edgeSpacing
            ),
            exitButton.widthAnchor.constraint(
                equalToConstant: 40
            ),
            
            editorButtonsBottomConstraint,
            editorButtonsContainerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            editorButtonsContainerView.widthAnchor.constraint(
                equalToConstant: 150
            ),
            editorButtonsContainerView.heightAnchor.constraint(
                equalToConstant: 40
            ),
            
            dateTextField.topAnchor.constraint(
                equalTo: topButtonsContainerView.bottomAnchor,
                constant: 2 * edgeSpacing
            ),
            dateTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: edgeSpacing
            ),
            dateTextField.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.5
            ),
            dateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            noteAreaContainer.topAnchor.constraint(
                equalTo: dateTextField.bottomAnchor,
                constant: edgeSpacing
            ),
            noteAreaContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: edgeSpacing
            ),
            noteAreaContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * edgeSpacing
            ),
            noteAreaContainer.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -1 * (4 * edgeSpacing + 40)
            ),
            
            imageLable.topAnchor.constraint(
                equalTo: noteAreaContainer.topAnchor,
                constant: edgeSpacing
            ),
            imageLable.leadingAnchor.constraint(
                equalTo: noteAreaContainer.leadingAnchor
            ),
            imageLable.trailingAnchor.constraint(
                equalTo: noteAreaContainer.trailingAnchor
            ),
            imageLable.heightAnchor.constraint(equalToConstant: 20),
            
            imagesContainerView.topAnchor.constraint(
                equalTo: imageLable.bottomAnchor,
                constant: 0.5 * edgeSpacing
            ),
            imagesContainerView.leadingAnchor.constraint(
                equalTo: noteAreaContainer.leadingAnchor,
                constant: edgeSpacing
            ),
            imagesContainerView.trailingAnchor.constraint(
                equalTo: noteAreaContainer.trailingAnchor,
                constant: -1 * edgeSpacing
            ),
            imagesContainerView.heightAnchor.constraint(equalToConstant: 82),
            
            addImageButton.topAnchor.constraint(
                equalTo: imagesContainerView.topAnchor
            ),
            addImageButton.trailingAnchor.constraint(
                equalTo: imagesContainerView.trailingAnchor
            ),
            addImageButton.bottomAnchor.constraint(
                equalTo: imagesContainerView.bottomAnchor
            ),
            addImageButton.widthAnchor.constraint(equalToConstant: 60),
            
            imageStackCoverView.topAnchor.constraint(
                equalTo: imagesContainerView.topAnchor
            ),
            imageStackCoverView.leadingAnchor.constraint(
                equalTo: imagesContainerView.leadingAnchor
            ),
            imageStackCoverView.trailingAnchor.constraint(
                equalTo: addImageButton.leadingAnchor,
                constant: -1 * edgeSpacing
            ),
            imageStackCoverView.bottomAnchor.constraint(
                equalTo: imagesContainerView.bottomAnchor
            ),
            
            imagesStackView.centerYAnchor.constraint(
                equalTo: imageStackCoverView.centerYAnchor
            ),
            imagesStackView.leadingAnchor.constraint(
                equalTo: imageStackCoverView.leadingAnchor,
                constant: edgeSpacing
            ),
            imagesStackView.heightAnchor.constraint(
                equalToConstant: 60
            ),
            
            noteTextLable.topAnchor.constraint(
                equalTo: imagesContainerView.bottomAnchor,
                constant: edgeSpacing
            ),
            noteTextLable.leadingAnchor.constraint(
                equalTo: noteAreaContainer.leadingAnchor
            ),
            noteTextLable.trailingAnchor.constraint(
                equalTo: noteAreaContainer.trailingAnchor
            ),
            noteTextLable.heightAnchor.constraint(equalToConstant: 20),
            
            noteInputTextField.topAnchor.constraint(
                equalTo: noteTextLable.bottomAnchor,
                constant: 0.5 * edgeSpacing
            ),
            noteInputTextField.leadingAnchor.constraint(
                equalTo: noteAreaContainer.leadingAnchor,
                constant: edgeSpacing
            ),
            noteInputTextField.trailingAnchor.constraint(
                equalTo: noteAreaContainer.trailingAnchor,
                constant: -1 * edgeSpacing
            ),
            noteInputTextField.bottomAnchor.constraint(
                equalTo: noteAreaContainer.bottomAnchor,
                constant: -1 * edgeSpacing
            ),
            
            boldButton.centerYAnchor.constraint(
                equalTo: editorButtonsContainerView.centerYAnchor
            ),
            boldButton.leadingAnchor.constraint(
                equalTo: editorButtonsContainerView.leadingAnchor,
                constant: edgeSpacing
            ),
            boldButton.widthAnchor.constraint(equalToConstant: 30),
            boldButton.heightAnchor.constraint(equalToConstant: 30),
            
            italicButton.centerYAnchor.constraint(
                equalTo: editorButtonsContainerView.centerYAnchor
            ),
            italicButton.leadingAnchor.constraint(
                equalTo: boldButton.trailingAnchor,
                constant: edgeSpacing
            ),
            italicButton.widthAnchor.constraint(equalToConstant: 30),
            italicButton.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
