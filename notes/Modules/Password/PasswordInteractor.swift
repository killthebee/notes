class PasswordInteractor: PasswordInteractorProtocol {
    
    weak var presenter: PasswordPresenterProtocol?
    
    required init(presenter: PasswordPresenter) {
        self.presenter = presenter
    }
}
