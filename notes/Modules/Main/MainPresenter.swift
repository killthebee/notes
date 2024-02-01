class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func downloadNotes() {
        interactor?.downloadNotes()
    }
    
    @MainActor
    func setNotes(_ notes: [Note]) async {
        view?.setNotes(notes)
    }
}
