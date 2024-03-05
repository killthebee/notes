import UIKit

class NoteViewController: UIViewController, NoteViewProtocol {
    
    // MARK: Dependencies -
    var presenter: NotePresenterProtocol?
    var mainVCDelegate: MainViewProtocol?
    private lazy var imagePicker = ImagePicker(
        presentationController: self,
        delegate: self
    )
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    // MARK: Data -
    var isBoldOn = false
    var isItalicOn = false
    var isTextInput = true
    var possibleFonts: [String: UIFont] = [:]
    let regularFonts: [String: UIFont] = [
        "regular": UIFont.systemFont(ofSize: 15, weight: .regular),
        "bold": UIFont.systemFont(ofSize: 15, weight: .bold),
        "italic": UIFont.italicSystemFont(ofSize: 15)
    ]
    let snellFonts: [String: UIFont] = [
        "regular": UIFont(name:"SnellRoundhand", size: 20)!,
        "bold": UIFont(name:"SnellRoundhand-Black", size: 20)!,
        "italic": UIFont(name:"SnellRoundhand", size: 20)!
    ]
    var noteObj: Note? = nil
    var addedImages: [UIImage] = []
    
    // MARK: Logic -
    func setNoteData(
        header: String?,
        date: String?,
        images: [UIImage],
        text: NSAttributedString?
    ) {
        self.dateTextField.text = date
        headerTextField.text = header
        noteInputTextField.attributedText = text
        
        imagesStackView.removeAllArrangedSubviews()
        addedImages = []
        images.forEach{
            let imageView = UIImageView(image: $0)
            imagesStackView.addArrangedSubview(imageView)
            addedImages.append($0)
        }
    }
    
    @objc
    func dateDoneButtonTapped() {
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc
    func handleAddImageClicked(_ sender: UIButton) {
        view.endEditing(true)
        self.imagePicker.present(from: sender)
    }
    
    @objc
    func dateCancelButtonTapped() {
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
    
    @objc
    func boldChangeTapped(_ sender: UIButton) {
        isBoldOn = isBoldOn ? false : true
        sender.backgroundColor = isBoldOn ? .blue : .clear
        let fontName = presenter?.interactor?.getFontForBoldSwitch(
            isBoldOn
        ) ?? "regular"
        
        presenter?.interactor?.makeNewAtrText(
            noteInputTextField.attributedText,
            range: noteInputTextField.selectedRange,
            fontName: fontName
        )
        
        let attrtext = noteInputTextField.attributedText
        let targetFont = possibleFonts[fontName]
        noteInputTextField.typingAttributes[
            NSAttributedString.Key.font
        ] = targetFont
        noteInputTextField.attributedText = attrtext
    }
    
    @objc
    func italicChangeTapped(_ sender: UIButton) {
        isItalicOn = isItalicOn ? false : true
        sender.backgroundColor = isItalicOn ? .blue : .clear
        
        let fontName = presenter?.interactor?.getFontForItalicSwitch(
            isItalicOn
        ) ?? "regular"
        
        presenter?.interactor?.makeNewAtrText(
            noteInputTextField.attributedText,
            range: noteInputTextField.selectedRange,
            fontName: fontName
        )
        
        let attrtext = noteInputTextField.attributedText
        let targetFont = possibleFonts[fontName]
        noteInputTextField.typingAttributes[
            NSAttributedString.Key.font
        ] = targetFont
        noteInputTextField.attributedText = attrtext
    }
    
    @objc
    func saveNote() {
        Task {
            let dbService = DBManager.shared
            if noteObj == nil {
                let images = addedImages.map{$0.jpegData(compressionQuality: 1)}
                let newRecord = await dbService.createNote(
                    header: headerTextField.text,
                    date: datePicker.date,
                    text: noteInputTextField.attributedText,
                    images: images
                )
                
                guard newRecord != nil else {
                    print("make bottom sheet pop up with retry buttom...")
                    return
                }
            } else {
                dbService.updateNote(
                    id: noteObj!.objectID,
                    header: headerTextField.text,
                    date: datePicker.date,
                    text: noteInputTextField.attributedText,
                    images: addedImages.map{$0.jpegData(compressionQuality: 1)}
                )
            }
            
            mainVCDelegate?.downloadNotes()
            presenter?.dismissRequested()
        }
    }
    
    @objc
    func dismissView() {
        presenter?.dismissRequested()
    }
    
    @objc
    func dismissViewAfterDelete() {
        presenter?.deleteNote(noteObj)
        mainVCDelegate?.downloadNotes()
        presenter?.dismissRequested()
    }
    
    // MARK: UI Elements -
    let saveButton = NoteControlButton("SAVE")
    let deleteButton = NoteControlButton("DELETE")
    let exitButton = NoteControlButton("<")
    
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
    
    private lazy var dateTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = cellsBackgroundColor
        field.layer.cornerRadius = 20
        field.inputView = datePicker
        field.textAlignment = .center
        field.textColor = dateColor
        
        return field
    }()
    
    private lazy var headerTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = cellsBackgroundColor
        field.layer.cornerRadius = 20
        field.textAlignment = .center
        field.textColor = dateColor
        field.placeholder = "header"
        field.tag = 1337
        field.delegate = self
        
        return field
    }()
    
    private let noteInputTextField: UITextView = {
        let view = UITextView()
        view.backgroundColor = buttonColor
        view.layer.cornerRadius = 20
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        return view
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
    
    private lazy var fontButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fontIcon"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = getFontMenu()
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private func getFontMenu() -> UIMenu {
        let regular = UIAction(title: "regular", image: nil) { (action) in
            self.possibleFonts = self.regularFonts
            
            let targetFont = self.possibleFonts["regular"]
            self.presenter?.interactor?.makeNewAtrText(
                self.noteInputTextField.attributedText,
                range: self.noteInputTextField.selectedRange,
                fontName: "regular"
            )
            
            let attrtext = self.noteInputTextField.attributedText
            self.noteInputTextField.typingAttributes[
                NSAttributedString.Key.font
            ] = targetFont
            self.noteInputTextField.attributedText = attrtext
            
        }
        let snell = UIAction(title: "snell", image: nil) { (action) in
            self.possibleFonts = self.snellFonts
            
            let targetFont = self.possibleFonts["regular"]
            self.presenter?.interactor?.makeNewAtrText(
                self.noteInputTextField.attributedText,
                range: self.noteInputTextField.selectedRange,
                fontName: "regular"
            )
            
            let attrtext = self.noteInputTextField.attributedText
            self.noteInputTextField.typingAttributes[
                NSAttributedString.Key.font
            ] = targetFont
            self.noteInputTextField.attributedText = attrtext
        }
        let menu = UIMenu(
            options: .displayInline,
            children: [regular, snell]
        )
        
        return menu
    }
    
    // MARK: VC setup -
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = mainBackgroundColor
        possibleFonts = regularFonts
        addSubviews()
        disableAutoresizing()
        setUpConstrains()
        addToolbars()
        dateDoneButtonTapped()
        addKeyboardNotifications()
        addTargetActionMethods()
        if let note = noteObj {
            presenter?.getNoteData(note, dateFormatter)
        }
    }
    
    private func addTargetActionMethods() {
        saveButton.addTarget(
            self,
            action: #selector(saveNote),
            for: .touchDown
        )
        exitButton.addTarget(
            self,
            action: #selector(dismissView),
            for: .touchDown
        )
        deleteButton.addTarget(
            self,
            action: #selector(dismissViewAfterDelete),
            for: .touchDown
        )
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
        let doneHeaderButton = UIBarButtonItem(
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
        headerTextField.inputAccessoryView = makeToolbar(
            barItems: [flexSpace, doneHeaderButton]
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
        if isTextInput {
            self.view.frame.origin.y = -250
            editorButtonsBottomConstraint?.constant = -150
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if isTextInput {
            self.view.frame.origin.y = 0
            editorButtonsBottomConstraint?.constant = -16
        }
    }
    
    private func addSubviews() {
        [topButtonsContainerView,dateTextField, noteAreaContainer,
         editorButtonsContainerView, headerTextField
        ].forEach{view.addSubview($0)}
        [saveButton, deleteButton, exitButton
        ].forEach{topButtonsContainerView.addSubview($0)}
        [imageLable, noteTextLable, imagesContainerView, noteInputTextField
        ].forEach{noteAreaContainer.addSubview($0)}
        [imageStackCoverView, addImageButton,
        ].forEach{imagesContainerView.addSubview($0)}
        imageStackCoverView.addSubview(imagesStackView)
        [boldButton, italicButton, fontButton
        ].forEach{editorButtonsContainerView.addSubview($0)}
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [topButtonsContainerView, editorButtonsContainerView, saveButton,
         deleteButton, exitButton, dateTextField, noteAreaContainer,
         imageLable, noteTextLable, imagesStackView, imagesContainerView,
         addImageButton, noteInputTextField, imageStackCoverView, boldButton,
         italicButton, headerTextField, fontButton
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
                equalToConstant: 153
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
                multiplier: 0.4
            ),
            dateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            headerTextField.topAnchor.constraint(
                equalTo: topButtonsContainerView.bottomAnchor,
                constant: 2 * edgeSpacing
            ),
            headerTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * edgeSpacing
            ),
            headerTextField.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.4
            ),
            headerTextField.heightAnchor.constraint(equalToConstant: 40),
            
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
            
            fontButton.centerYAnchor.constraint(
                equalTo: editorButtonsContainerView.centerYAnchor
            ),
            fontButton.leadingAnchor.constraint(
                equalTo: italicButton.trailingAnchor,
                constant: edgeSpacing
            ),
            fontButton.widthAnchor.constraint(equalToConstant: 30),
            fontButton.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
