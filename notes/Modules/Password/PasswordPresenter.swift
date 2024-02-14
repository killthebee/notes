class PasswordPresenter: PasswordPresenterProtocol {
    
    weak var view: PasswordViewProtocol?
    var interactor: PasswordInteractorProtocol?
    var router: PasswordRouterProtocol?
    
    required init(view: PasswordViewController) {
        self.view = view
    }
}
