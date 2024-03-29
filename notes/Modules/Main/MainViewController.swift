import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    
    // MARK: Dependencies -
    var presenter: MainPresenterProtocol?
    
    // MARK: Data -
    var notes: [Note] = []
    
    // MARK: Logic -
    func setNotes(_ notesFromBD: [Note]) {
        notes = []
        notes = notesFromBD
        collectionView.reloadData()
    }
    
    @objc
    func thumbsUpButtonPressed(_ sender: UIButton) {
        sender.startAnimatingPressActions()
        presenter?.presentNoteScreen(nil)
    }
    
    // MARK: UI Elements -
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout.init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            TopBannerCell.self,
            forSupplementaryViewOfKind: "Stretchy",
            withReuseIdentifier: TopBannerCell.cellIdentifier
        )
        
        collectionView.register(
            YearSubHeaderCell.self,
            forCellWithReuseIdentifier: YearSubHeaderCell.cellIdentifier
        )
        
        collectionView.register(
            NoteCell.self,
            forCellWithReuseIdentifier: NoteCell.cellIdentifier
        )
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = collectionView.supplementaryView(
            forElementKind: "Stretchy",
            at: IndexPath(item: 0, section: 0)
        ) as? TopBannerCell {
            header.scrollviewDidScroll(scrollView: collectionView)
         }
    }
    
    lazy var addNoteButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "pencil.and.outline"), for: .normal)
        button.addTarget(
            self,
            action: #selector(thumbsUpButtonPressed),
            for: .touchUpInside
        )
        button.backgroundColor = buttonColor
        
        return button
    }()
    
    // MARK: VC Setup -
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
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let launchesCount = delegate.currentTimesOfOpenApp
        if launchesCount == 1 {
            craeteExampleNote()
        } else {
            downloadNotes()
        }
    }
    
    func downloadNotes() {
        presenter?.downloadNotes()
    }
    
    func craeteExampleNote() {
        Task {
            guard
                let exampleImageData1 = UIImage(named: "example1")?.resized(toHeight: 60)?.pngData(),
                let exampleImageData2 = UIImage(named: "example2")?.resized(toHeight: 60)?.pngData(),
                let _ = await DBManager.shared.createNote(
                    header: "Example Header",
                    date: Date(),
                    text: NSAttributedString(string: "Example note text"),
                    images: [exampleImageData1, exampleImageData2]
                )
            else {
                return
            }
            
            downloadNotes()
        }
    }
    
    private func addSubviews() {
        [collectionView, addNoteButton
        ].forEach{view.addSubview($0)}
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [collectionView, addNoteButton
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private var buttonBottomConstraint: NSLayoutConstraint?
    
    func setUpConstrains() {
        buttonBottomConstraint = addNoteButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -1 * view.frame.height * 0.1
        )
        
        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.01),
            
            addNoteButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            buttonBottomConstraint!,
            addNoteButton.widthAnchor.constraint(equalToConstant: 50),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let buttonBottomConstraint = buttonBottomConstraint {
            buttonBottomConstraint.constant = -1 * view.frame.height * 0.1
        }
        addNoteButton.layer.cornerRadius = 0.5 * addNoteButton.bounds.size.width
    }
}

extension MainViewController {
    
    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            if sectionIndex == 0 {
                return MainVCLayouts.shared.yearSubHeaderLayouts()
            }
            
            return MainVCLayouts.shared.notesLayout()
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
