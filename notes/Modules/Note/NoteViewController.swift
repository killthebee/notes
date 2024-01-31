import UIKit

class NoteViewController: UIViewController, NoteViewProtocol {
    
    var presenter: NotePresenterProtocol?
    lazy var imagePicker = ImagePicker(
        presentationController: self,
        delegate: self
    )
    
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
    
    private let noteInputTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = buttonColor
        field.layer.cornerRadius = 20
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
    
    private func configure() {
        view.backgroundColor = mainBackgroundColor
        addSubviews()
        disableAutoresizing()
        setUpConstrains()
        addToolbars()
        // set date field to today for new entries
        dateDoneButtonTapped()
    }
    
    private func addToolbars() {
        let doneButton = UIBarButtonItem(
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
            barItems: [cancelButton, flexSpace, doneButton]
        )
    }
    
    private func addSubviews() {
        [topButtonsContainerView, editorButtonsContainerView,
         dateTextField, noteAreaContainer
        ].forEach{view.addSubview($0)}
        [saveButton, deleteButton, exitButton
        ].forEach{topButtonsContainerView.addSubview($0)}
        [imageLable, noteTextLable, imagesContainerView, noteInputTextField
        ].forEach{noteAreaContainer.addSubview($0)}
        [imageStackCoverView, addImageButton,
        ].forEach{imagesContainerView.addSubview($0)}
        imageStackCoverView.addSubview(imagesStackView)
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [topButtonsContainerView, editorButtonsContainerView, saveButton,
         deleteButton, exitButton, dateTextField, noteAreaContainer,
         imageLable, noteTextLable, imagesStackView, imagesContainerView,
         addImageButton, noteInputTextField, imageStackCoverView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    func setUpConstrains() {
        let edgeSpacing: CGFloat = 16
        
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
            
            editorButtonsContainerView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -1 * edgeSpacing
            ),
            editorButtonsContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: edgeSpacing
            ),
            editorButtonsContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -1 * edgeSpacing
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
                equalTo: editorButtonsContainerView.topAnchor,
                constant: -1 * edgeSpacing
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
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
