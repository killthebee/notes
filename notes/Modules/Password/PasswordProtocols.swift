protocol PasswordViewProtocol: AnyObject {
    var numsIput: String { get set }
    func addDot()
    func removeDot()
}

protocol PasswordConfiguratorProtocol: AnyObject {
    func configure(with viewController: PasswordViewController)
}

protocol PasswordPresenterProtocol: AnyObject {
    func numPressed(num: String?)
    func setNewInput(nums: String)
    func addDot()
    func removeDot()
}

protocol PasswordInteractorProtocol: AnyObject {
    func numPressed(num: String?, _ currentInput: String)
}

protocol PasswordRouterProtocol: AnyObject {
    
}
