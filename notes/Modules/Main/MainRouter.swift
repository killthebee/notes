class MainRouter: MainRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    required init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    // present Note screen func
}
