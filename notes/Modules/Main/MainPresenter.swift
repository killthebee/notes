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
    
    func presentNoteScreen(_ note: Note?) {
        invalidatePulseAnimtaion()
        router?.presentNoteScreen(note)
    }
    
    func startPulseAnimationTask() {
        interactor?.startAnimationTask()
    }
    
    func pulse() {
        view?.startPulseAnimation()
    }
    
    func invalidatePulseAnimtaion() {
        interactor?.invalidateAnimationTask()
    }
    
    func stopPulseAnimation() {
        view?.stopPulseAnimation()
    }
    func continueAnimation() {
        view?.continueAnimation()
    }
}
