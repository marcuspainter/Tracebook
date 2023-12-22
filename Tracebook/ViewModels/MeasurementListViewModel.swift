//
//  MeasurementListViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 20/12/2023.
//

import Foundation

@MainActor
class MeasurementListViewModel: ObservableObject {

    @Published var measurements: [MeasurementModel] = []

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

    func getMeasurementList() async {

        measurements.removeAll()
        measurementStore.removeAll()

        // await getMicrophones()
        // await getInterfaces()

        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.getMicrophones()
            }
            group.addTask {
                await self.getInterfaces()
            }
        }

        var cursor: Int = 0
        let measurementListResponse = await apiClient.getMeasurementList(cursor: cursor)
        if let measurementList = measurementListResponse?.response.results {

            for measurementItem in measurementList {
                let model = convertListToModel(measurement: measurementItem)
                measurementStore.append(model)
            }

            measurements = measurementStore

            for model in measurementStore {
                let content = await apiClient.getMeasurementContent(id: model.additionalContent)
                convertContentToModel(model: model, content: content!.response)
                model.microphone = microphones[model.microphone] ?? model.microphone
                model.interface = interfaces[model.interface] ?? model.interface
            }
        }

        // Update view
        measurements = measurementStore
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
        let reseult = text.map { Double($0) ?? 0.0 }
        return reseult
    }

    func processMagnitude(model: MeasurementModel, delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newMagnitudeData = model.tfMagnitude.enumerated().map {
            let index = $0
            let f = model.tfFrequency[index]
            let c = model.tfCoherence[index]
            let m = $1
            if c < threshold {
                return (f, Double.nan)
            } else {
                return (f, m)
            }
        }
        return newMagnitudeData
    }

    func processPhase(model: MeasurementModel, delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {

        let newPhaseData = model.tfPhase.enumerated().map {
            let index = $0
            let f = model.tfFrequency[index]
            let c = model.tfCoherence[index]
            if c < threshold {
                return (f, Double.nan)
            }

            var p = $1
            p = p + (f * 360.0 * (delay * -1 / 1000))
            if isPolarityInverted {
                p = p + 180.0
            }
            p = wrapTo180(p)
            return (f, p)
        }
        return newPhaseData
    }

    func processCoherence(model: MeasurementModel, delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newCoherenceData = model.tfCoherence.enumerated().map {
            let index = $0
            let f = model.tfFrequency[index]
            let c = $1
            if c < threshold {
                return (f, Double.nan)
            } else {
                return (f, (c / 3.33))
            }
        }
        return newCoherenceData
    }

    private func wrapTo180(_ x: Double) -> Double {
        var y = (x + 180.0).truncatingRemainder(dividingBy: 360.0)
        if y < 0.0 {
            y += 360.0
        }
        return y - 180.0
    }

}
