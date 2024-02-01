import Foundation

protocol NoteViewProtocol: AnyObject {
    var presenter: NotePresenterProtocol? { get set }
    var isBoldOn: Bool { get set }
    var isItalicOn: Bool { get set }
    func setNewText(
        _ text: NSMutableAttributedString,
        range: NSRange,
        fontName: String
    )
}

protocol NoteConfiguratorProtocol: AnyObject {
    func configure(with viewController: NoteViewController)
}

protocol NotePresenterProtocol: AnyObject {
    var interactor: NoteInteractorProtocol? { get set }
    var view: NoteViewProtocol? { get set }
}

protocol NoteInteractorProtocol: AnyObject {
    func getFontForBoldSwitch(_ isBoldOn: Bool) -> String
    func getFontForItalicSwitch(_ isItalicOn: Bool) -> String
    func makeNewAtrText(
        _ atrText: NSAttributedString?,
        range: NSRange?,
        fontName: String
    )
}

protocol NoteRouterProtocol: AnyObject {
    
}
