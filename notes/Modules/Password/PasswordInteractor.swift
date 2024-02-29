import Foundation

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
        
        let newNums = currentInput + num
        presenter?.setNewInput(nums: newNums)
        presenter?.addDot()
        if newNums.count == 4 {
            presenter?.handleInput()
        }
    }
    
    func isCorrectPW(_ numsInput: String) -> Bool {
        let storedPw = KeyChainManager().readPW(
            service: "pw-storage",
            account: "pw"
        ) ?? "not a pw"
        if storedPw == numsInput {
            presenter?.presentMainScreen(cleanStart: false)
            return true
        }
        
        return false
    }
    
    func handlePWSave(_ numsInput: String) {
        KeyChainManager().save(
            Data(numsInput.utf8),
            service: "pw-storage",
            account: "pw"
        )
        presenter?.presentMainScreen(cleanStart: true)
    }
    
    func resetApp() {
        DBManager().flushAppData()
        KeyChainManager().delete(service: "pw-storage", account: "pw")
    }
}
