import Foundation

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol?
    let dbService = DBManager.shared
    
    var animationTaskTimer: Timer?
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func downloadNotes() {
        Task {
            guard let notes = await dbService.fetchNotes() else { return }
            await presenter?.setNotes(notes)
        }
    }
    
    func startAnimationTask() {
        self.presenter?.pulse()
        animationTaskTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: true
        ) { _ in
            self.presenter?.stopPulseAnimation()
            self.presenter?.continueAnimation()
        }
    }
    
    func invalidateAnimationTask() {
        animationTaskTimer?.invalidate()
    }
}
