import CoreData
import UIKit

class DBManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "notes")
        container.loadPersistentStores(
            completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
        })
        return container
    }()
    
    func createNote(
        header: String?,
        date: Date,
        text: AttributedString?,
        images: [UIImage]
    ) async -> Note {
        let context = persistentContainer.viewContext
        let newNote = Note(context: context)
//        newNote.date
        
    }
}
