import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol?
    
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
        [collectionView,
        ].forEach{view.addSubview($0)}
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [collectionView,
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    func setUpConstrains() {
        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.01)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
