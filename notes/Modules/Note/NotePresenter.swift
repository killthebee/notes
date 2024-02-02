class NotePresenter: NotePresenterProtocol {
    
    weak var view: NoteViewProtocol?
    var interactor: NoteInteractorProtocol?
    var router: NoteRouterProtocol?
    
    required init(view: NoteViewController) {
        self.view = view
    }
    
    func getNoteData(_ note: Note) {
        interactor?.getNoteData(note)
    }
    
    func dismissRequested() {
        router?.dismissRequested()
    }
}
