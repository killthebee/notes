import Foundation

class NotePresenter: NotePresenterProtocol {
    
    weak var view: NoteViewProtocol?
    var interactor: NoteInteractorProtocol?
    var router: NoteRouterProtocol?
    
    required init(view: NoteViewController) {
        self.view = view
    }
    
    func getNoteData(_ note: Note, _ dateFormatter: DateFormatter) {
        interactor?.getNoteData(note, dateFormatter)
    }
    
    func dismissRequested() {
        router?.dismissRequested()
    }
    
    func deleteNote(_ note: Note?) {
        interactor?.deleteNote(note)
    }
}
