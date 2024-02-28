//
//  MeasurementListViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 20/12/2023.
//

import Foundation

@MainActor
class MeasurementListViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var measurements: [MeasurementModel] = []

    private var tracebookAPI = TracebookAPI()
    public var measurementStore = MeasurementStore()

    // Local dictonaries
    private var microphones: [String: String] = [:]
    private var interfaces: [String: String] = [:]
    private var analyzers: [String: String] = [:]

    func search(searchText: String) async {
        if !searchText.isEmpty {
            measurements = measurementStore.models.filter { $0.title.uppercased().contains(searchText.uppercased()) }
        } else {
            measurements = measurementStore.models
        }
    }
    
    func loadMeasurements() async {
        
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
        
        let dateString = measurementStore.models.isEmpty ? "2000-01-01" : (measurementStore.models.first?.createdDate ?? "2001-01-01")

        print("Start from: \(dateString)")
        
        var newMeasurementModels: [MeasurementModel] = []

        var cursor: Int = 0
        while true {
            guard let measurementListResponse = await tracebookAPI.getMeasurementListbyDate(cursor: cursor, dateString: dateString) else {
                break
            }

            let measurementList = measurementListResponse.response.results
            for measurementItem in measurementList {
                let model = convertListToModel(measurement: measurementItem)
                
                if self.measurementStore.models.first(where: { $0.id == model.id }) != nil {
                    print("Duplicate: \(model.title)")
                }
                else {
                    newMeasurementModels.append(model)
                }
            }
            
            cursor += measurementListResponse.response.count
            if measurementListResponse.response.remaining == 0 {
                break
            }
        }
        
        self.measurementStore.models = newMeasurementModels + self.measurementStore.models
        self.measurements = measurementStore.models

        for model in newMeasurementModels {
            if let content = await tracebookAPI.getMeasurementContent(id: model.additionalContent) {
                convertContentToModel(model: model, content: content.response)
                model.microphone = microphones[model.microphone] ?? model.microphone
                model.interface = interfaces[model.interface] ?? model.interface
                model.analyzer = analyzers[model.analyzer] ?? model.analyzer
            } else {
                print("No content")
            }
        }

        self.measurements = self.measurementStore.models
    }

    func getMeasurementList() async {
        
        measurements.removeAll()
        measurementStore.models.removeAll()

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

        var cursor: Int = 0
        while true {
            let measurementListResponse = await tracebookAPI.getMeasurementList(cursor: cursor)

            if let measurementList = measurementListResponse?.response.results {
                for measurementItem in measurementList {
                    let model = convertListToModel(measurement: measurementItem)
                    measurementStore.models.append(model)
                }
            }

            cursor += (measurementListResponse?.response.count)!
            if measurementListResponse?.response.remaining == 0 {
                break
            }
        }

        measurements = measurementStore.models

        for model in measurementStore.models {
            if let content = await tracebookAPI.getMeasurementContent(id: model.additionalContent) {
                convertContentToModel(model: model, content: content.response)
                model.microphone = microphones[model.microphone] ?? model.microphone
                model.interface = interfaces[model.interface] ?? model.interface
                model.analyzer = analyzers[model.analyzer] ?? model.analyzer
            } else {
                print("No content")
            }
        }

        measurements = measurementStore.models
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

    private func convertListToModel(measurement: MeasurementItem) -> MeasurementModel {
        let model = MeasurementModel()

        model.additionalContent = measurement.additionalContent ?? ""
        model.approved = measurement.approved ?? ""
        model.commentCreator = measurement.commentCreator ?? ""
        model.productLaunchDateText = measurement.productLaunchDateText ?? ""
        model.thumbnailImage = measurement.thumbnailImage ?? ""
        model.upvotes = measurement.upvotes ?? []
        model.createdDate = measurement.createdDate ?? ""
        model.createdBy = measurement.createdBy ?? ""
        model.modifiedDate = measurement.modifiedDate ?? ""
        model.slug = measurement.slug ?? ""
        model.moderator1 = measurement.moderator1 ?? ""
        model.resultPublic = measurement.resultPublic ?? false
        model.title = measurement.title ?? ""
        model.publishDate = measurement.publishDate ?? ""
        model.admin1Approved = measurement.admin1Approved ?? ""
        model.moderator2 = measurement.moderator2 ?? ""
        model.admin2Approved = measurement.admin2Approved ?? ""
        model.id = measurement.id ?? ""
        model.loudspeakerTags = measurement.loudspeakerTags ?? []
        model.emailSent = measurement.emailSent  ?? false

        // Link to Tracebook website
        model.tracebookURL = "https://trace-book.org/measurement/\(measurement.slug ?? "")"

        return model
    }

    private func convertContentToModel(model: MeasurementModel, content: MeasurementContent) {

        // Measurement Content
        model.firmwareVersion = content.firmwareVersion ?? ""
        model.loudspeakerBrand = content.loudspeakerBrand ?? ""
        model.category = content.category ?? ""
        model.delayLocator = content.delayLocator
        model.distance = content.distance         // Nilable
        model.dspPreset = content.dspPreset ?? ""
        model.photoSetup = content.photoSetup ?? ""
        model.fileAdditional = content.fileAdditional ?? []
        model.fileTFCSV = content.fileTFCSV ?? ""
        model.notes = content.notes ?? ""
        //model.createdDate = content.createdDate ?? ""
        model.createdBy = content.createdBy ?? ""
        model.modifiedDate = content.modifiedDate ?? ""
        model.distanceUnits = content.distanceUnits ?? ""
        model.crestFactorM = content.crestFactorM ?? 0.0
        model.crestFactorPink = content.crestFactorPink ?? 0.0
        model.loudspeakerModel = content.loudspeakerModel ?? ""
        model.calibrator = content.calibrator ?? ""
        model.measurementType = content.measurementType ?? ""
        model.presetVersion = content.presetVersion ?? ""
        model.temperature = content.temperature         // Nilable
        model.tempUnits = content.tempUnits ?? ""
        model.responseLoudspeakerBrand = content.responseLoudspeakerBrand ?? ""
        model.coherenceScale = content.coherenceScale ?? ""
        model.analyzer = content.analyzer ?? ""
        model.fileTFNative = content.fileTFNative ?? ""
        model.splGroundPlane = content.splGroundPlane ?? false
        model.responseLoudspeakerModel = content.responseLoudspeakerModel ?? ""
        model.systemLatency = content.systemLatency         // Nilable
        model.microphone = content.microphone ?? ""
        model.measurement = content.measurement ?? ""
        model.interface = content.interface ?? ""
        model.micCorrectionCurve = content.micCorrectionCurve ?? ""
        model.medal = content.medal ?? ""
        model.fileIRWAV = content.fileIRWAV ?? ""
        model.windscreen = content.windscreen ?? ""
        model.presetNA = content.presetNA ?? false
        model.presetVersionNA = content.presetVersionNA ?? false
        model.firmwareVersionNA = content.firmwareVersionNA ?? false
        model.inputMeter = content.inputMeter ?? 0.0

        model.tfFrequency = convertCSVToArray(dataText: content.tfJSONFrequency)
        model.tfMagnitude = convertCSVToArray(dataText: content.tfJSONMagnitude)
        model.tfPhase = convertCSVToArray(dataText: content.tfJSONPhase)
        model.tfCoherence = convertCSVToArray(dataText: content.tfJSONCoherence)

        // Scale to 0...100
        model.tfCoherence = model.tfCoherence.map { $0 * 100.0}
    }

    private func convertCSVToArray(dataText: String?) -> [Double] {
        let array = dataText?.components(separatedBy: ",") ?? []
        let text = array.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let result = text.map { Double($0) ?? 0.0 }
        return result
    }

}
