//
//  Container.swift
//  SoundboardWidgetExtension
//
//  Created by Fabian Kuschke on 20.09.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    //let container: NSPersistentCloudKitContainer //NSPersistentContainer
    let container: NSPersistentContainer //NSpersistenCloudContainer


    init(inMemory: Bool = false) {
        //container = NSPersistentCloudKitContainer(name: "User") //NSPersistentContainer
        container = NSPersistentContainer(name: "User") //NSPersistentContainer

        let description = container.persistentStoreDescriptions.first
        
#if os(iOS)
        let storeURL = AppGroup.facts.containerURL.appendingPathComponent("User.plist")
        description?.url = storeURL
#endif
        //description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.fku.WatchSoundboard1")
        if inMemory {
            print("in memory")
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        //container.persistentStoreDescriptions = [description] //Use?
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            //let user = Sounds(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
}

public enum AppGroup: String {
  case facts = "group.fku.WatchSoundboard"

  public var containerURL: URL {
    switch self {
    case .facts:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}

