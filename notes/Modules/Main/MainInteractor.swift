class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol?
    let dbService = DBManager.shared
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func downloadNotes() {
        Task {
            guard let notes = await dbService.fetchNotes() else { return }
            await presenter?.setNotes(notes)
        }
    }
}
