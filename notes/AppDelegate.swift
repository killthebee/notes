import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let userDefaults = UserDefaults.standard
    var currentTimesOfOpenApp: Int = 0

    func saveTimesOfOpenApp() -> Void {
        userDefaults.set(currentTimesOfOpenApp, forKey: "timesOfOpenApp")
    }

    func getCurrentTimesOfOpenApp() -> Int {
        return userDefaults.integer(forKey: "timesOfOpenApp") + 1
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]?) -> Bool {
        self.currentTimesOfOpenApp = getCurrentTimesOfOpenApp()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveTimesOfOpenApp()
        self.saveContext()
    }

    // MARK: UISceneSession Lifecycle -
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}

    // MARK: Core Data stack -
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

    // MARK: Core Data Saving support -
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

