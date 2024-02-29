class PasswordPresenter: PasswordPresenterProtocol {
    
    weak var view: PasswordViewProtocol?
    var interactor: PasswordInteractorProtocol?
    var router: PasswordRouterProtocol?
    
    required init(view: PasswordViewController) {
        self.view = view
    }
    
    func numPressed(num: String?) {
        guard let view = view else { return }
        interactor?.numPressed(num: num, view.numsInput)
    }
    
    func setNewInput(nums: String) {
        view?.numsInput = nums
    }
    
    func addDot() {
        view?.addDot()
    }
    
    func removeDot() {
        view?.removeDot()
    }
    
    func handleInput() {
        view?.handleInput()
    }
    
    func presentMainScreen(cleanStart: Bool) {
        router?.presentMainScreen(cleanStart: cleanStart)
    }
    
    func isCorrectPW(_ numsInput: String) -> Bool {
        interactor?.isCorrectPW(numsInput) ?? false
    }
    
    func handlePWSave() {
        guard let view = view else { return }
        interactor?.handlePWSave(view.numsInput)
    }
    
    func resetApp() {
        interactor?.resetApp()
    }
}
