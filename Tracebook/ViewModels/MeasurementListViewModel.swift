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
    @Published var measurementViewModels: [MeasurementViewModel] = []

    private var apiClient = TracebookAPIClient()
    private var measurementStore: [MeasurementModel] = []
    private var microphones: [String: String] = [:]
    private var interfaces: [String: String] = [:]

    func search(searchText: String) async {
        if !searchText.isEmpty {
            measurements = measurementStore.filter { $0.title.uppercased().contains(searchText.uppercased()) }
        } else {
            measurements = measurementStore
        }
    }

    func getMeasurementList() async {

        measurements.removeAll()
        measurementStore.removeAll()
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.getMicrophones()
            }
            group.addTask {
                await self.getInterfaces()
            }
        }

        var cursor: Int = 0
        while true {
            let measurementListResponse = await apiClient.getMeasurementList(cursor: cursor)
        
            if let measurementList = measurementListResponse?.response.results {
                for measurementItem in measurementList {
                    let model = convertListToModel(measurement: measurementItem)
                    measurementStore.append(model)
                }
            }
            
            cursor = cursor + (measurementListResponse?.response.count)!
            if measurementListResponse?.response.remaining == 0 {
                break
            }
        }
            
        measurements = measurementStore

        for model in measurementStore {
            if let content = await apiClient.getMeasurementContent(id: model.additionalContent) {
                convertContentToModel(model: model, content: content.response)
                model.microphone = microphones[model.microphone] ?? model.microphone
                model.interface = interfaces[model.interface] ?? model.interface
            }
            else {
                print("No content")
            }
        }
        
        measurements = measurementStore
    }

    private func getMicrophones() async {
        let microphoneResponse = await apiClient.getMicrophoneList()
        if let microphoneList = microphoneResponse?.response.results {
            for microphone in microphoneList {
                if let id = microphone.id, let brand = microphone.micBrandModel {
                    microphones[id] = brand
                }
            }
        }
    }

    private func getInterfaces() async {
        let interfaceResponse = await apiClient.getInterfaceList()
        if let interfaceList = interfaceResponse?.response.results {
            for interface in interfaceList {
                if let id = interface.id, let brand = interface.brandModel {
                    interfaces[id] = brand
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
        // model.createdDate = ISO8601DateFormatter().date(from: measurement.createdDate ?? "")
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
        model.loudspeakerTags = measurement.loudspeakerTags  ?? []
        model.emailSent = measurement.emailSent  ?? false

        return model
    }

    private func convertContentToModel(model: MeasurementModel, content: MeasurementContent) {

        // Measurement Content
        model.firmwareVersion = content.firmwareVersion ?? ""
        model.loudspeakerBrand = content.loudspeakerBrand ?? ""
        model.category = content.category ?? ""
        model.delayLocator = content.delayLocator ?? 0.0
        model.distance = content.distance ?? 0.0
        model.dspPreset = content.dspPreset ?? ""
        model.photoSetup = content.photoSetup ?? ""
        model.fileAdditional = content.fileAdditional ?? []
        model.fileTFCSV = content.fileTFCSV ?? ""
        model.notes = content.notes ?? ""
        model.createdDate = content.createdDate ?? ""
        model.createdBy = content.createdBy ?? ""
        model.modifiedDate = content.modifiedDate ?? ""
        model.distanceUnits = content.distanceUnits ?? ""
        model.crestFactorM = content.crestFactorM ?? 0.0
        model.crestFactorPink = content.crestFactorPink ?? 0.0
        model.loudspeakerModel = content.loudspeakerModel ?? ""
        model.calibrator = content.calibrator ?? ""
        model.measurementType = content.measurementType ?? ""
        model.presetVersion = content.presetVersion ?? ""
        model.temperature = content.temperature ?? 0.0
        model.tempUnits = content.tempUnits ?? ""
        model.responseLoudspeakerBrand = content.responseLoudspeakerBrand ?? ""
        model.coherenceScale = content.coherenceScale ?? ""
        model.analyzer = content.analyzer ?? ""
        model.fileTFNative = content.fileTFNative ?? ""
        model.splGroundPlane = content.splGroundPlane ?? false
        model.responseLoudspeakerModel = content.responseLoudspeakerModel ?? ""
        model.systemLatency = content.systemLatency ?? 0.0
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

        model.tfFrequency = convertDataArray(dataText: content.tfJSONFrequency)
        model.tfMagnitude = convertDataArray(dataText: content.tfJSONMagnitude)
        model.tfPhase = convertDataArray(dataText: content.tfJSONPhase)
        model.tfCoherence = convertDataArray(dataText: content.tfJSONCoherence)

        // Scale to 0...100
        model.tfCoherence = model.tfCoherence.map { $0 * 100.0}
    }

    private func convertDataArray(dataText: String?) -> [Double] {
        let array = dataText?.components(separatedBy: ",") ?? []
        let text = array.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let result = text.map { Double($0) ?? 0.0 }
        return result
    }

}
