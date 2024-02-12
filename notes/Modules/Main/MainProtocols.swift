protocol MainViewProtocol: AnyObject {
    func downloadNotes()
    func setNotes(_ notesFromBD: [Note])
    func startPulseAnimationTask()
    func startPulseAnimation()
    func stopPulseAnimation()
    func continueAnimation()
}

protocol MainConfiguratorProtocol: AnyObject {
    func configure(with viewController: MainViewController)
}

protocol MainPresenterProtocol: AnyObject {
    func downloadNotes()
    func setNotes(_ notes: [Note]) async
    func presentNoteScreen(_ note: Note?)
    func pulse()
    func stopPulseAnimation()
    func startPulseAnimationTask()
    func continueAnimation()
}

protocol MainInteractorProtocol: AnyObject {
    func downloadNotes()
    func startAnimationTask()
    func invalidateAnimationTask()
}

protocol MainRouterProtocol: AnyObject {
    func presentNoteScreen(_ note: Note?)
}
