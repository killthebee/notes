class PasswordConfigurator: PasswordConfiguratorProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: PasswordViewController) {
        let presenter = PasswordPresenter(view: viewController)
        let router = PasswordRouter(assembly: assembly, view: viewController)
        let interactor = PasswordInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
