import UIKit

protocol NoteViewProtocol: AnyObject {
    var presenter: NotePresenterProtocol? { get set }
    var isBoldOn: Bool { get set }
    var isItalicOn: Bool { get set }
    func setNewText(
        _ text: NSMutableAttributedString,
        range: NSRange,
        fontName: String
    )
    func setNoteData(
        header: String?,
        date: String?,
        images: [UIImage],
        text: NSAttributedString?
    )
    func dismissViewAfterDelete()
}

protocol NoteConfiguratorProtocol: AnyObject {
    func configure(with viewController: NoteViewController)
}

protocol NotePresenterProtocol: AnyObject {
    var interactor: NoteInteractorProtocol? { get set }
    var view: NoteViewProtocol? { get set }
    func getNoteData(_ note: Note, _ dateFormatter: DateFormatter)
    func dismissRequested()
    func deleteNote(_ note: Note?)
}

protocol NoteInteractorProtocol: AnyObject {
    func getFontForBoldSwitch(_ isBoldOn: Bool) -> String
    func getFontForItalicSwitch(_ isItalicOn: Bool) -> String
    func makeNewAtrText(
        _ atrText: NSAttributedString?,
        range: NSRange?,
        fontName: String
    )
    func getNoteData(_ note: Note, _ dateFormatter: DateFormatter)
    func deleteNote(_ note: Note?)
}

protocol NoteRouterProtocol: AnyObject {
    func dismissRequested()
}
