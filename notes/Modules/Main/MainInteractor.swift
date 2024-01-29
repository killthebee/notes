class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenter?
    
    required init(presenter: MainPresenter) {
        self.presenter = presenter
    }
}
