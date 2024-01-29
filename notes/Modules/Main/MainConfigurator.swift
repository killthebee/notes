class MainConfigurator: MainViewProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter(view: viewController)
        let router = MainRouter(assembly: assembly, view: viewController)
        let interacor = MainInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interacor
        presenter.router = router
    }
}
