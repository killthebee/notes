import CoreData
import UIKit

class DBManager {
    
    static let shared = DBManager()
    
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
    
    @MainActor
    func createNote(
        header: String?,
        date: Date,
        text: NSAttributedString?,
        images: [Data?]
    ) async -> Note? {
        let context = persistentContainer.viewContext
        let newNote = Note(context: context)
        newNote.date = date
        newNote.header = header ?? ""
        newNote.text = text ?? NSAttributedString(string: "")
        
        for imageData in images {
            let newImage = NoteImage(context: context)
            newImage.imageData = imageData
            newNote.addToImages(newImage)
        }
        
        do {
            try context.save()
            return newNote
        } catch let error {
            print("Failed to create: \(error)")
        }
        
        return nil
    }
    
    func fetchNote(_ id: ObjectIdentifier) async -> Note? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", id as! CVarArg)
        fetchRequest.relationshipKeyPathsForPrefetching = ["images"]
        
        do {
            let note = try context.fetch(fetchRequest)
            return note.first
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        
        return nil
    }
    
    func fetchNotes(_ id: ObjectIdentifier) async -> [Note]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.relationshipKeyPathsForPrefetching = ["images"]
        
        do {
            let note = try context.fetch(fetchRequest)
            return note
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        
        return nil
    }
}
