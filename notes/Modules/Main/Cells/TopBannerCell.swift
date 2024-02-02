import UIKit

class TopBannerCell: UICollectionReusableView {
    
    static let cellIdentifier = "CFTTopBannerCollectionViewCell"
    
    let bannerImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "banner1")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    func configure(){
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(
            equalTo: bannerImageView.widthAnchor
        ).isActive = translatesAutoresizingMaskIntoConstraints
        containerViewHeight = containerView.heightAnchor.constraint(
            equalTo: self.heightAnchor
        )
        containerViewHeight.isActive = true
        
        imageViewBottom = bannerImageView.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor
        )
        imageViewBottom.isActive = true
        imageViewHeight = bannerImageView.heightAnchor.constraint(
            equalTo: containerView.heightAnchor
        )
        imageViewHeight.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func scrollviewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
