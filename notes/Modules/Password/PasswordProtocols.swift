protocol PasswordViewProtocol: AnyObject {
    var numsInput: String { get set }
    func addDot()
    func removeDot()
    func handleInput()
}

protocol PasswordConfiguratorProtocol: AnyObject {
    func configure(with viewController: PasswordViewController)
}

protocol PasswordPresenterProtocol: AnyObject {
    func numPressed(num: String?)
    func setNewInput(nums: String)
    func addDot()
    func removeDot()
    func handleInput()
    func presentMainScreen(cleanStart: Bool)
    func isCorrectPW(_ numsInput: String) -> Bool
    func handlePWSave()
    func resetApp()
}

protocol PasswordInteractorProtocol: AnyObject {
    func numPressed(num: String?, _ currentInput: String)
    func isCorrectPW(_ numsInput: String) -> Bool
    func handlePWSave(_ numsInput: String)
    func resetApp()
}

protocol PasswordRouterProtocol: AnyObject {
    func presentMainScreen(cleanStart: Bool)
}
