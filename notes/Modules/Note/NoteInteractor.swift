import UIKit

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
    
    func getNoteData(_ note: Note, _ dateFormatter: DateFormatter) {
        var date: String? = nil
        if let dateData = note.date {
            date = dateFormatter.string(from: dateData)
        }
        
        var images: [UIImage] = []
        for noteImageRelatedObject in note.images ?? [] {
            guard
                let noteImage = noteImageRelatedObject as? NoteImage,
                let imageData = noteImage.imageData,
                let newImage = UIImage(data: imageData, scale:1.0)
            else
                { return }
            images.append(newImage)
        }
        
        presenter?.view?.setNoteData(
            header: note.header,
            date: date,
            images: images,
            text: note.text
        )
    }
    
    func deleteNote(_ note: Note?) {
        let dbService = DBManager.shared
        guard let objId = note?.objectID else { return }
        dbService.deleteNote(id: objId)
    }
}
