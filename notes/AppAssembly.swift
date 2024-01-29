import UIKit

class AppAssembly {}

// MARK: MainScreen -
extension AppAssembly {
    func makeMainScreen() -> Presentable {
        let mainVC = MainViewController()
        let configurator = MainConfigurator(assembly: self)
        configurator.configure(with: mainVC)
        
        return mainVC
    }
}
