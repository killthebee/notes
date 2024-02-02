class MainRouter: MainRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    required init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func presentNoteScreen(_ note: Note?) {
        guard
            let noteVC = assembly.makeNoteScreen() as? NoteViewController,
            let mainVC = view as? MainViewProtocol
        else {
            return
        }
        
        noteVC.mainVCDelegate = mainVC
        noteVC.modalPresentationStyle = .fullScreen
        noteVC.noteObj = note
        view?.present(noteVC)
    }
}
