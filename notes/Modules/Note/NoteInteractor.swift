class NoteInteractor: NoteInteractorProtocol {
    
    weak var presenter: NotePresenter?
    
    required init(presenter: NotePresenter) {
        self.presenter = presenter
    }
}
