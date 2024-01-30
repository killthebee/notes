class NotePresenter: NotePresenterProtocol {
    
    weak var view: NoteViewProtocol?
    var interactor: NoteInteractorProtocol?
    var router: NoteRouterProtocol?
    
    required init(view: NoteViewController) {
        self.view = view
    }
}
