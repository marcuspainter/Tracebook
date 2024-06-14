//
//  TracebookActor.swift
//  Tracebook
//
//  Created by Marcus Painter on 28/04/2024.
//

import CoreData
import Foundation
@preconcurrency import OSLog

/*
@MainActor
actor TracebookActor {
    //static let shared = TracebookActor()
    
    // Local dictionaries
    private var microphones: [String: String] = [:]
    private var interfaces: [String: String] = [:]
    private var analyzers: [String: String] = [:]

    private let inMemory: Bool
    private var notificationToken: NSObjectProtocol?
    private var lastToken: NSPersistentHistoryToken?
    private let lock = NSLock()
    let tracebookAPI = TracebookAPI()

    let logger = Logger(subsystem: "com.marcuspainter.com.Tracebook", category: "persistence")
    
    var container: NSPersistentContainer!

    init(inMemory: Bool = false) {
        self.inMemory = inMemory
        /*
                // Observe Core Data remote change notifications on the queue where the changes were made.
                let notificationToken = NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { _ in
                    self.logger.debug("Received a persistent store remote change notification.")
                    Task {
                        await self.fetchPersistentHistory()
                    }
                }
         */
        // notificationToken = await addObserver()

        Task {
            await self.makeContainer()
            await self.addObserver()
        }
    }

    deinit {
        Task {
            await removeObserver()
        }
    }

    // Can't removeObserver directly in deinit
    func removeObserver() {
        if let observer = notificationToken {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func addObserver() {
        notificationToken = NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { _ in
            self.logger.debug("Received a persistent store remote change notification.")
            Task {
                await self.fetchPersistentHistory()
            }
        }
    }

    func makeContainer() {
        let container = NSPersistentContainer(name: "Tracebook")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        // Enable persistent store remote change notifications
        /// - Tag: persistentStoreRemoteChange
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        // Enable persistent history tracking
        /// - Tag: persistentHistoryTracking
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // This sample refreshes UI by consuming store changes via persistent history tracking.
        /// - Tag: viewContextMergeParentChanges
        let viewContext = container.viewContext
        
        viewContext.name = "viewContextActor"
        viewContext.automaticallyMergesChangesFromParent = false
        // - Tag: viewContextMergePolicy
        viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

        viewContext.undoManager = nil
        viewContext.shouldDeleteInaccessibleFaults = true
        self.container = container
    }

    func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            logger.debug("\(error.localizedDescription)")
        }
    }
    
    func fetchPersistentHistoryTransactionsAndChanges() async throws {
            logger.debug("Start fetching persistent history changes from the store...")

            // Use the container to create and configure a new context each time within an async context.
            // This ensures that the context is confined to the operation for which it is created.
            try await withCheckedThrowingContinuation { continuation in
                let taskContext = container.newBackgroundContext()
                taskContext.name = "persistentHistoryContext"
                taskContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
                taskContext.undoManager = nil

                taskContext.perform {
                    do {
                        let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
                        let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
                        if let history = historyResult?.result as? [NSPersistentHistoryTransaction], !history.isEmpty {
                            // Process history...
                            continuation.resume()
                        } else {
                            self.logger.debug("No persistent history transactions found.")
                            continuation.resume(throwing: TracebookError.persistentHistoryChangeError)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }

            logger.debug("Finished merging history changes.")
        }
    
    /// Creates and configures a private queue context.
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = container.newBackgroundContext()

        taskContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        logger.debug("Received \(history.count) persistent history transactions.")
        // Update view context with objectIDs from history change request.
        /// - Tag: mergeChanges
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                let notification = transaction.objectIDNotification()
                viewContext.mergeChanges(fromContextDidSave: notification)
                self.lastToken = transaction.token
            }
        }
    }
    
    private func newBatchInsertRequest(with propertyList: [[String: Any]]) -> NSBatchInsertRequest {
        let batchInsertRequest = NSBatchInsertRequest(entity: MeasurementEntity.entity(), objects: propertyList)
        return batchInsertRequest
    }
    
    func getLastDate() -> String {
        let viewContext = container.viewContext

        // Create a fetch request with a string filter
        // for an entity’s name
        let fetchRequest: NSFetchRequest<MeasurementEntity> = MeasurementEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \MeasurementEntity.createdDate, ascending: false)]
        fetchRequest.fetchLimit = 1

        var date = "2000-01-01T00:00:00.000Z"
        // Perform the fetch request to get the objects
        viewContext.perform {
            do {
                let measurements = try viewContext.fetch(fetchRequest)
                if let measurement = measurements.first {
                    date = measurement.createdDate ?? date
                }
            } catch {
                self.logger.debug("Fetch failed \(error)")
            }
        }
        return date
    }

    
    /// Fetches the tracebook feed from the remote server, and imports it into Core Data.
    func fetchMeasurements() async throws {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.getMicrophones()
            }
            group.addTask {
                await self.getInterfaces()
            }
            group.addTask {
                await self.getAnalyzers()
            }
        }

        let lastDate = getLastDate()
        var cursor: Int = 0
        while true {
            logger.debug("Get measurements")
            guard let measurementListResponse = await tracebookAPI.getMeasurementListByDate(
                cursor: cursor, dateString: lastDate) else {
                break
            }

            var propertiesList: [[String: Any]] = []
            for result in measurementListResponse.response.results {
                let measurementProperties = TracebookMapper.measurementBodyToProperties(body: result)
                propertiesList.append(measurementProperties)
            }

            logger.debug("Received \(propertiesList.count) records.")

            // Import the JSON into Core Data.
            logger.debug("Start importing measurement data to the store...")
            try await importMeasurements(from: propertiesList)
            logger.debug("Finished importing data.")

            cursor += measurementListResponse.response.count
            if measurementListResponse.response.remaining == 0 {
                break
            }
        }
    }

    /// Uses `NSBatchInsertRequest` (BIR) to import a JSON dictionary into the Core Data store on a private queue.
    private func importMeasurements(from propertiesList: [[String: Any]]) async throws {
        guard !propertiesList.isEmpty else { return }

        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importMeasurements"

        /// - Tag: performAndWait
        try taskContext.performAndWait {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(with: propertiesList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            self.logger.debug("Failed to execute batch insert request.")
            throw TracebookError.batchInsertError
        }
    
        logger.debug("Successfully inserted data.")
    }
    
    func deleteEntityData()  {
        let entityName = "MeasurementEntity"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = container.newBackgroundContext()

        context.perform {
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                self.logger.debug("Delete ended")
            } catch {
                self.logger.debug("Error deleting data for entity \(entityName): \(error)")
            }
        }
    }
    
     func getMicrophones() async {
        let microphoneResponse = await tracebookAPI.getMicrophoneList()
        if let microphoneList = microphoneResponse?.response.results {
            for microphone in microphoneList {
                if let id = microphone.id, let brand = microphone.micBrandModel {
                    microphones[id] = brand
                }
            }
        }
    }

    private func getInterfaces() async {
        let interfaceResponse = await tracebookAPI.getInterfaceList()
        if let interfaceList = interfaceResponse?.response.results {
            for interface in interfaceList {
                if let id = interface.id, let brand = interface.brandModel {
                    interfaces[id] = brand
                }
            }
        }
    }

    private func getAnalyzers() async {
        let analyzerResponse = await tracebookAPI.getAnalyzerList()
        if let analyzerList = analyzerResponse?.response.results {
            for analyzer in analyzerList {
                if let id = analyzer.id, let name = analyzer.name {
                    analyzers[id] = name
                }
            }
        }
    }
}
*/
