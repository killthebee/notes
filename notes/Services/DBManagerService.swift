import CoreData
import UIKit

class DBManager {
    
    static let shared = DBManager()
    
    @objc(NSAttributedStringTransformer)
    class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
        override class var allowedTopLevelClasses: [AnyClass] {
            return super.allowedTopLevelClasses + [NSAttributedString.self]
        }
    }
    
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
        newNote.isActive = true
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
    
    
    func fetchNotes() async -> [Note]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        fetchRequest.relationshipKeyPathsForPrefetching = ["images"]
        let dateSort = NSSortDescriptor(key: #keyPath(Note.date), ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            let note = try context.fetch(fetchRequest)
            return note
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        
        return nil
    }
    
    func updateNote(
        id: NSManagedObjectID,
        header: String?,
        date: Date,
        text: NSAttributedString?,
        images: [Data?]
    ) {
        let context = persistentContainer.viewContext
        do {
            guard
                let currentNote = context.object(with: id) as? Note
            else
                { return }
            currentNote.date = date
            currentNote.header = header ?? ""
            currentNote.text = text ?? NSAttributedString(string: "")
            
            guard let existingImages = currentNote.images else { return }
            currentNote.removeFromImages(existingImages)
            for imageData in images {
                let newImage = NoteImage(context: context)
                newImage.imageData = imageData
                currentNote.addToImages(newImage)
            }
            
            try context.save()
        } catch let error {
            print("Failed to update: \(error)")
        }
   }
    
    func deleteNote(id: NSManagedObjectID) {
        let context = persistentContainer.viewContext
        do {
            guard
                let currentNote = context.object(with: id) as? Note
            else
                { return }
            context.delete(currentNote)
            try context.save()
        } catch let error {
            print("Failed to delete the spend: \(error)")
        }
    }
    
    func flushAppData() {
        let context = persistentContainer.viewContext
        let imagesFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
            entityName: "NoteImage"
        )
        let imagesDeleteReuqest = NSBatchDeleteRequest(
            fetchRequest: imagesFetchRequest
        )
        
        do {
            try persistentContainer.persistentStoreCoordinator.execute(
                imagesDeleteReuqest,
                with: context
            )
        } catch let error as NSError {
            print("fieled to delete images: \(error)")
        }
        
        let notesFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
            entityName: "Note"
        )
        let notesDeleteReuqest = NSBatchDeleteRequest(
            fetchRequest: notesFetchRequest
        )
        
        do {
            try persistentContainer.persistentStoreCoordinator.execute(
                notesDeleteReuqest,
                with: context
            )
        } catch let error as NSError {
            print("fieled to delete notes: \(error)")
        }
    }
}
