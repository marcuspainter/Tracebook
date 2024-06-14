//
//  Persistence.swift
//  CoreDataEx
//
//  Created by Marcus Painter on 19/02/2024.
//

import CoreData

final class PersistenceController: Sendable {
    static let shared = PersistenceController()

    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0 ..< 10 {
            let newItem = Measurement(context: viewContext)
            newItem.id = UUID().uuidString
            newItem.title = "RCF"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this 
            // function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let fileManager = FileManager.default
        let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first

        print(applicationSupportURL ?? "")

        DoubleArrayValueTransformer.register()
        StringArrayValueTransformer.register()

        container = NSPersistentContainer(name: "Tracebook")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this
                // function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is 
                 * locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Duplicates policy. Overwrite with new.
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // deleteStoreFiles()

        deleteEntityData(entityName: "Measurement")

        // deleteEntityData(entityName: "MeasurementEntity")
        // deleteEntityData(entityName: "MeasurementContentEntity")
        // deleteEntityData(entityName: "MicrophoneEntity")
    }

    func deleteEntityData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = container.viewContext

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("Delete ended")
        } catch {
            print("Error deleting data for entity \(entityName): \(error)")
        }
    }

    func deleteStoreFiles() {
        let fileManager = FileManager.default
        guard let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory,
                                                           in: .userDomainMask).first else {
            return
        }

        let coordinator = container.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            do {
                try coordinator.remove(store)

                // Delete the SQLite file if it exists
                let storeURL = store.url
                if let storeURL = storeURL, fileManager.fileExists(atPath: storeURL.path) {
                    try fileManager.removeItem(at: storeURL)
                    print(storeURL.path)
                } else {
                    print(".sqlite file not found")
                }

                // Delete associated model files
                let modelFileName = store.configurationName
                let modelURL = applicationSupportURL.appendingPathComponent("\(modelFileName).momd")
                if fileManager.fileExists(atPath: modelURL.path) {
                    try fileManager.removeItem(at: modelURL)
                } else {
                    print(".momd file not found")
                }
            } catch {
                print("Error deleting CoreData store: \(error)")
            }
        }
    }
}
