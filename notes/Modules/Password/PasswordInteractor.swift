class PasswordInteractor: PasswordInteractorProtocol {
    
    weak var presenter: PasswordPresenterProtocol?
    
    required init(presenter: PasswordPresenter) {
        self.presenter = presenter
    }
    
    func numPressed(num: String?, _ currentInput: String) {
        guard let num = num else { return }
        if num == "<" {
            var nums = currentInput
            let _ = nums.popLast()
            presenter?.setNewInput(nums: nums)
            presenter?.removeDot()
            return
        }
        if currentInput.count == 4 { return }
        
        let newNums = currentInput + num
        presenter?.setNewInput(nums: newNums)
        presenter?.addDot()
    }
}
