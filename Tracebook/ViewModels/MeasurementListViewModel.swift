//
//  MeasurementListViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 20/12/2023.
//

import Foundation

@MainActor
@Observable
final class MeasurementListViewModel: Sendable {
    var searchText: String = ""
    var measurements: [MeasurementModel] = []

    public var measurementStore = MeasurementStore()

    private var tracebookAPI = TracebookAPI()
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

    func go() async{
        let model = MeasurementModel()
        model.title = "Title"
        model.id = "XXX"
        measurements.append(model)
    }

    func loadMeasurements() async throws {
        try await getMicrophones()
        try await getInterfaces()
        try await getAnalyzers()

        let dateString = measurementStore.models.isEmpty ? "2000-01-01" : (measurementStore.models.first?.createdDate ?? "2001-01-01")

        print("Start from: \(dateString)")

        var newMeasurementModels: [MeasurementModel] = []

        var cursor: Int = 0
        while true {
            guard let measurementListResponse = try await tracebookAPI.getMeasurementListByDate(cursor: cursor, dateString: dateString) else {
                break
            }

            let measurementList = measurementListResponse.response.results
            for measurementItem in measurementList {
                let model = convertListToModel(measurement: measurementItem)

                if measurementStore.models.first(where: { $0.id == model.id }) != nil {
                    print("Duplicate: \(model.title)")
                } else {
                    newMeasurementModels.append(model)
                }
            }

            cursor += measurementListResponse.response.count
            if measurementListResponse.response.remaining == 0 {
                break
            }
        }

        measurementStore.models = newMeasurementModels + measurementStore.models
        measurements = measurementStore.models

        for model in newMeasurementModels {
            if let content = try await tracebookAPI.getMeasurementContent(id: model.additionalContent) {
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

    private func getMicrophones() async throws {
        do {
            let microphoneResponse = try await tracebookAPI.getMicrophoneList()
            if let microphoneList = microphoneResponse?.response.results {
                for microphone in microphoneList {
                    if let id = microphone.id, let brand = microphone.micBrandModel {
                        microphones[id] = brand
                    }
                }
            }
        } catch {
            throw error
        }
    }

    private func getInterfaces() async throws {
        do {
            let interfaceResponse = try await tracebookAPI.getInterfaceList()
            if let interfaceList = interfaceResponse?.response.results {
                for interface in interfaceList {
                    if let id = interface.id, let brand = interface.brandModel {
                        interfaces[id] = brand
                    }
                }
            }
        } catch {
            throw error
        }
    }

    private func getAnalyzers() async throws {
        do {
            let analyzerResponse = try await tracebookAPI.getAnalyzerList()
            if let analyzerList = analyzerResponse?.response.results {
                for analyzer in analyzerList {
                    if let id = analyzer.id, let name = analyzer.name {
                        analyzers[id] = name
                    }
                }
            }
        } catch {
            throw error
        }
    }

    private func convertListToModel(measurement: MeasurementBody) -> MeasurementModel {
        let model = MeasurementModel()

        model.id = measurement.id
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
        model.isPublic = measurement.isPublic ?? false
        model.title = measurement.title ?? ""
        model.publishDate = measurement.publishDate ?? ""
        model.admin1Approved = measurement.admin1Approved ?? ""
        model.moderator2 = measurement.moderator2 ?? ""
        model.admin2Approved = measurement.admin2Approved ?? ""
        model.loudspeakerTags = measurement.loudspeakerTags ?? []
        model.emailSent = measurement.emailSent ?? false

        // Link to Tracebook website
        model.tracebookURL = "https://trace-book.org/measurement/\(measurement.slug ?? "")"

        return model
    }

    private func convertContentToModel(model: MeasurementModel, content: MeasurementContentBody) {
        // Measurement Content
        model.firmwareVersion = content.firmwareVersion ?? ""
        model.loudspeakerBrand = content.loudspeakerBrand ?? ""
        model.category = content.category ?? ""
        model.delayLocator = content.delayLocator
        model.distance = content.distance // Nilable
        model.dspPreset = content.dspPreset ?? ""
        model.photoSetup = content.photoSetup ?? ""
        model.fileAdditional = content.fileAdditional ?? []
        model.fileTFCSV = content.fileTFCSV ?? ""
        model.notes = content.notes ?? ""
        // model.createdDate = content.createdDate ?? ""
        model.createdBy = content.createdBy ?? ""
        model.modifiedDate = content.modifiedDate ?? ""
        model.distanceUnits = content.distanceUnits ?? ""
        model.crestFactorM = content.crestFactorM ?? 0.0
        model.crestFactorPink = content.crestFactorPink ?? 0.0
        model.loudspeakerModel = content.loudspeakerModel ?? ""
        model.calibrator = content.calibrator ?? ""
        model.measurementType = content.measurementType ?? ""
        model.presetVersion = content.presetVersion ?? ""
        model.temperature = content.temperature // Nilable
        model.tempUnits = content.tempUnits ?? ""
        model.responseLoudspeakerBrand = content.responseLoudspeakerBrand ?? ""
        model.coherenceScale = content.coherenceScale ?? ""
        model.analyzer = content.analyzer ?? ""
        model.fileTFNative = content.fileTFNative ?? ""
        model.splGroundPlane = content.splGroundPlane ?? false
        model.responseLoudspeakerModel = content.responseLoudspeakerModel ?? ""
        model.systemLatency = content.systemLatency // Nilable
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
        model.tfCoherence = model.tfCoherence.map { $0 * 100.0 }
    }

    private func convertCSVToArray(dataText: String?) -> [Double] {
        let array = dataText?.components(separatedBy: ",") ?? []
        let text = array.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let result = text.map { Double($0) ?? 0.0 }
        return result
    }
}
