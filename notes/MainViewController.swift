import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainBackgroundColor
        view.addSubview(initLable)
        initLable.frame = view.bounds
    }

    let initLable: UILabel = {
        let lable = UILabel()
        lable.text = "hmmm1"
        lable.textAlignment = .center
        lable.textColor = .white
        
        return lable
    }()
}
