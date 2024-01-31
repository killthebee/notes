import UIKit

class NoteControlButton: UIButton {
    
    convenience init(_ buttonTitle: String) {
        self.init()
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = 20
        backgroundColor = buttonColor
    }
}
