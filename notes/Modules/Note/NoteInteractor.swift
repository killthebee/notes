import Foundation

class NoteInteractor: NoteInteractorProtocol {
    
    weak var presenter: NotePresenter?
    
    required init(presenter: NotePresenter) {
        self.presenter = presenter
    }
    
    func getFontForBoldSwitch(_ isBoldOn: Bool) -> String {
        return isBoldOn ? "bold" : "regular"
    }
    
    func getFontForItalicSwitch(_ isItalicOn: Bool) -> String {
        return isItalicOn ? "italic" : "regular"
    }
    
    func makeNewAtrText(
        _ atrText: NSAttributedString?,
        range: NSRange?,
        fontName: String
    ) {
        if range == nil || range?.length == 0 { return }
        guard let atrText = atrText else { return }
        let atrMutableText = NSMutableAttributedString(
            attributedString: atrText
        )
        presenter?.view?.setNewText(
            atrMutableText,
            range: range!,
            fontName: fontName
        )
    }
}
