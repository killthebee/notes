class NoteConfigurator: NoteConfiguratorProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: NoteViewController) {
        let presenter = NotePresenter(view: viewController)
        let router = NoteRouter(assembly: assembly, view: viewController)
        let interacor = NoteInteractor(presenter: presenter)
//        
        viewController.presenter = presenter
        presenter.interactor = interacor
        presenter.router = router
    }
}
