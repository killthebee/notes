protocol MainViewProtocol: AnyObject {
    func downloadNotes()
    func setNotes(_ notesFromBD: [Note])
}

protocol MainConfiguratorProtocol: AnyObject {
    func configure(with viewController: MainViewController)
}

protocol MainPresenterProtocol: AnyObject {
    func downloadNotes()
    func setNotes(_ notes: [Note]) async
    func presentNoteScreen(_ note: Note?)
}

protocol MainInteractorProtocol: AnyObject {
    func downloadNotes()
}

protocol MainRouterProtocol: AnyObject {
    func presentNoteScreen(_ note: Note?)
}
