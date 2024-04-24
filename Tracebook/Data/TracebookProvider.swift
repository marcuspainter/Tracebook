/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A class to fetch data from the remote server and save it to the Core Data store.
 */

import CoreData
import OSLog

class TracebookProvider {
    // Local dictionaries
    private var microphones: [String: String] = [:]
    private var interfaces: [String: String] = [:]
    private var analyzers: [String: String] = [:]
    
    @discardableResult
    static func makePreviews(count: Int) -> [MeasurementEntity] {
        var measurements = [MeasurementEntity]()
        let viewContext = TracebookProvider.preview.container.viewContext
        for index in 0 ..< count {
            let measurement = MeasurementEntity(context: viewContext)
            measurement.id = UUID().uuidString
            measurement.title = "Speaker \(index)"
            measurements.append(measurement)
        }
        return measurements
    }

    // MARK: Logging

    let logger = Logger(subsystem: "com.marcuspainter.com.Tracebook", category: "persistence")
    
    // MARK: Network API
    
    let tracebookAPI = TracebookAPI()

    // MARK: Core Data

    /// A shared tracebook provider for use within the main app bundle.
    static let shared = TracebookProvider()

    /// A tracebook provider for use with canvas previews.
    static let preview: TracebookProvider = {
        let provider = TracebookProvider(inMemory: true)
        TracebookProvider.makePreviews(count: 10)
        return provider
    }()

    private let inMemory: Bool
    private var notificationToken: NSObjectProtocol?

    private init(inMemory: Bool = false) {
        self.inMemory = inMemory

        // Observe Core Data remote change notifications on the queue where the changes were made.
        notificationToken = NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { _ in
            self.logger.debug("Received a persistent store remote change notification.")
            Task {
                await self.fetchPersistentHistory()
            }
        }
        
        DoubleArrayValueTransformer.register()
        StringArrayValueTransformer.register()
    }

    deinit {
        if let observer = notificationToken {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    /// A persistent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?

    /// A persistent container to set up the Core Data stack.
    lazy var container: NSPersistentContainer = {
        /// - Tag: persistentContainer
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
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.name = "viewContext"
        /// - Tag: viewContextMergePolicy
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    /// Creates and configures a private queue context.
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }
    
    private func getMicrophones() async {
        let microphoneResponse = await tracebookAPI.getMicrophoneList()
        if let microphoneList = microphoneResponse?.response.results {
            for microphone in microphoneList {
                if let id = microphone.id, let brand = microphone.micBrandModel {
                    self.microphones[id] = brand
                }
            }
        }
    }

    private func getInterfaces() async {
        let interfaceResponse = await tracebookAPI.getInterfaceList()
        if let interfaceList = interfaceResponse?.response.results {
            for interface in interfaceList {
                if let id = interface.id, let brand = interface.brandModel {
                    self.interfaces[id] = brand
                }
            }
        }
    }

    private func getAnalyzers() async {
        let analyzerResponse = await tracebookAPI.getAnalyzerList()
        if let analyzerList = analyzerResponse?.response.results {
            for analyzer in analyzerList {
                if let id = analyzer.id, let name = analyzer.name {
                    self.analyzers[id] = name
                }
            }
        }
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
        do {
            let measurements = try viewContext.fetch(fetchRequest)
            if let measurement = measurements.first {
                date = measurement.createdDate ?? date
            }
        } catch {
            logger.debug("Fetch failed \(error)")
        }
        return date
    }
    
    func fetchMeasurementsForUpdate() -> [MeasurementEntity] {
        let viewContext = container.viewContext

        let fetchRequest: NSFetchRequest<MeasurementEntity> = MeasurementEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \MeasurementEntity.createdDate, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "%K == NIL", "contentId")

        var measurements: [MeasurementEntity] = []
        // Perform the fetch request to get the objects
        do {
            measurements = try viewContext.fetch(fetchRequest)
        } catch {
            logger.debug("Fetch failed \(error)")
        }
        return measurements
    }
    
    func fetchMeasurement(id: String) -> MeasurementEntity? {
        let viewContext = container.viewContext
        var measurement: MeasurementEntity? = nil

        // Create a fetch request with a string filter
        // for an entity’s name
        let fetchRequest: NSFetchRequest<MeasurementEntity> = MeasurementEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        // Perform the fetch request to get the objects
        do {
            let measurements = try viewContext.fetch(fetchRequest)
            measurement = measurements.first
        } catch {
            logger.debug("Fetch failed \(error)")
        }
        return measurement
    }

    func fetchMeasurementContents() async throws {
        
        let viewContext = container.viewContext
        
        var measurements: [MeasurementEntity] = []
        measurements = fetchMeasurementsForUpdate()
        guard measurements.count > 0 else {
            logger.debug("No content updates needed.")
            return
        }
        
        logger.debug("Start getting content data...")
        
        //var propertiesList: [[String: Any]] = []
        var count: Int = 0
        for measurement in measurements {
            if let contentId = measurement.additionalContent {
                let measurementContentResponse = await tracebookAPI.getMeasurementContent(id: contentId)
                
                logger.debug("Content for \(measurement.title ?? "")")
                if let measurementContentBody = measurementContentResponse?.response {
                    //var measurementContentProperties = TracebookMapper.measurementContentBodyToProperties(body: measurementContentBody)
                    //measurementContentProperties["id"] = measurement.id
                    //measurementContentProperties["microphone"] = microphones[microphone] ?? microphone
                    //measurementContentProperties["interface"] = interfaces[interface] ?? interface
                    //measurementContentProperties["analyzer"]  = analyzers[analyzer] ?? analyzer
                    //propertiesList.append(measurementContentProperties)
                    
                    let microphone = measurementContentBody.microphone ?? ""
                    let interface = measurementContentBody.interface ?? ""
                    let analyzer = measurementContentBody.analyzer ?? ""
                    
                    let microphoneText = microphones[microphone] ?? microphone
                    let interfaceText = interfaces[interface] ?? interface
                    let analyzerText  = analyzers[analyzer] ?? analyzer
                    
                    let body = measurementContentBody
                    measurement.contentId = body.id
                    
                    measurement.analyzer = analyzerText
                    measurement.microphone = microphoneText
                    measurement.interface = interfaceText
                    
                    measurement.calibrator = body.calibrator
                    measurement.coherenceScale = body.coherenceScale
                    measurement.delayLocator = body.delayLocator ?? 0.0
                    measurement.distance = body.distance ?? 0.0
                    measurement.distanceUnits = body.distanceUnits
                    measurement.fileIRWAV = body.fileIRWAV
                    measurement.fileTFCSV = body.fileTFCSV
                    measurement.fileTFNative = body.fileTFNative
                    measurement.medal = body.medal
                    measurement.micCorrectionCurve = body.micCorrectionCurve
                    measurement.systemLatency = body.systemLatency ?? 0.0
                    measurement.temperature = body.temperature ?? 0.0
                    measurement.tempUnits = body.tempUnits
                    measurement.tfJSONCoherence = TracebookMapper.csvToDoubleArray(body.tfJSONCoherence)
                    measurement.tfJSONFrequency = TracebookMapper.csvToDoubleArray(body.tfJSONFrequency)
                    measurement.tfJSONMagnitude = TracebookMapper.csvToDoubleArray(body.tfJSONMagnitude)
                    measurement.tfJSONPhase = TracebookMapper.csvToDoubleArray(body.tfJSONPhase)
                    measurement.windscreen = body.windscreen
                
                    Task { @MainActor in
                        do {
                            try viewContext.save()
                        } catch {
                           print("Error")
                       }
                    }
                    
                }
            }
            count += 1
           //if count % 10 == 0 {
                //try await importMeasurements(from: propertiesList)
                // propertiesList = []
           //}
        }
        
        // Import the JSON into Core Data.
        //logger.debug("Start importing content data to the store...")
        //try await importMeasurements(from: propertiesList)
        //logger.debug("Finished importing content data.")
        //logger.debug("Content done.")
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

        var propertiesList: [[String: Any]] = []
        let lastDate = getLastDate()
        var cursor: Int = 0
        while true {
            logger.debug("Get measurements")
            guard let measurementListResponse = await tracebookAPI.getMeasurementListByDate(
                cursor: cursor, dateString: lastDate) else {
                break
            }

            for result in measurementListResponse.response.results {
                
                let measurementProperties = TracebookMapper.measurementBodyToProperties(body: result)
/*
                if let contentId =  result.additionalContent {
                    logger.debug("Get measurement content \(result.title ?? "")")
                    let measurementContentResponse = await tracebookAPI.getMeasurementContent(id: contentId)
                    
                    if let measurementContentBody = measurementContentResponse?.response {
                        let measurementContentProperties = TracebookMapper.measurementContentBodyToProperties(body: measurementContentBody)
                        measurementProperties.merge(measurementContentProperties){ (_, new) in new }
                    }
                }
*/
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
        try await taskContext.perform {
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

    private func newBatchInsertRequest(with propertyList: [[String: Any]]) -> NSBatchInsertRequest {
        let batchInsertRequest = NSBatchInsertRequest(entity: MeasurementEntity.entity(), objects: propertyList)
        /*
         var index = 0
         let total = propertyList.count

         // Provide one dictionary at a time when the closure is called.
         let batchInsertRequest = NSBatchInsertRequest(entity: MeasurementEntity.entity(), dictionaryHandler: { dictionary in
             guard index < total else { return true }
             let properties = propertyList[index]

             dictionary.addEntries(from: properties)
             index += 1
             return false
         })
         */
        return batchInsertRequest
    }

    func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            logger.debug("\(error.localizedDescription)")
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        let taskContext = newTaskContext()
        taskContext.name = "persistentHistoryContext"
        logger.debug("Start fetching persistent history changes from the store...")

        try await taskContext.perform {
            // Execute the persistent history change since the last transaction.
            /// - Tag: fetchHistory
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                self.mergePersistentHistoryChanges(from: history)
                return
            }

            self.logger.debug("No persistent history transactions found.")
            throw TracebookError.persistentHistoryChangeError
        }

        logger.debug("Finished merging history changes.")
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        logger.debug("Received \(history.count) persistent history transactions.")
        // Update view context with objectIDs from history change request.
        /// - Tag: mergeChanges
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                /*
                 logger.debug("transaction", transaction.changes?.count)
                 if let changes = transaction.changes {
                     for change in changes {
                         let names = change.updatedProperties?.map { $0.name }
                 logger.debug("changes \(change.changeType) properties \(names)")
                     }
                 }
                 */

                let notification = transaction.objectIDNotification()
                viewContext.mergeChanges(fromContextDidSave: notification)
                self.lastToken = transaction.token
            }
        }
    }

    func deleteEntityData() {
        let entityName = "MeasurementEntity"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = container.viewContext

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            logger.debug("Delete ended")
        } catch {
            logger.debug("Error deleting data for entity \(entityName): \(error)")
        }
    }
}

func getCoreDataDBPath() {
    let path = FileManager
        .default
        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .last?
        .absoluteString
        .replacingOccurrences(of: "file://", with: "")
        .removingPercentEncoding

    print("Core Data DB Path :: \(path ?? "Not found")")
}