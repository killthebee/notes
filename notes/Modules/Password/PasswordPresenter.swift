class PasswordPresenter: PasswordPresenterProtocol {
    
    weak var view: PasswordViewProtocol?
    var interactor: PasswordInteractorProtocol?
    var router: PasswordRouterProtocol?
    
    required init(view: PasswordViewController) {
        self.view = view
    }
    
    func numPressed(num: String?) {
        guard let view = view else { return }
        interactor?.numPressed(num: num, view.numsIput)
    }
    
    func setNewInput(nums: String) {
        view?.numsIput = nums
    }
    
    func addDot() {
        view?.addDot()
    }
    
    func removeDot() {
        view?.removeDot()
    }
}
