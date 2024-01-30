import UIKit

class AppAssembly {}

// MARK: Main Screen -
extension AppAssembly {
    func makeMainScreen() -> Presentable {
        let mainVC = MainViewController()
        let configurator = MainConfigurator(assembly: self)
        configurator.configure(with: mainVC)
        
        return mainVC
    }
}

// MARK: Note Screen -
extension AppAssembly {
    func makeNoteScreen() -> Presentable {
        let noteVC = NoteViewController()
        let configurator = NoteConfigurator(assembly: self)
        configurator.configure(with: noteVC)
        
        return noteVC
    }
}
