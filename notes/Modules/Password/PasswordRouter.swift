class PasswordRouter: PasswordRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    required init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func presentMainScreen(cleanStart: Bool) {
        guard
            let mainVC = assembly.makeMainScreen() as? MainViewController
        else {
            return
        }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.needExampleNote = cleanStart
        view?.present(mainVC)
    }
}
