import Foundation

// MARK: - MeasurementContentResponse
struct MeasurementContentResponse: Codable {
    let response: MeasurementContent
}

// MARK: - MeasurementContent
struct MeasurementContent: Codable {
    let firmwareVersion: String?
    let loudspeakerBrand: String?
    let category: String?
    let delayLocator: Double?
    let distance: Double?
    let dspPreset: String?
    let photoSetup: String?
    let fileAdditional: [String]?
    let fileTFCSV: String?
    let notes: String?
    let createdDate: String?
    let createdBy: String?
    let modifiedDate: String?
    let distanceUnits: String?
    let crestFactorM: Double?
    let crestFactorPink: Double?
    let loudspeakerModel: String?
    let calibrator: String?
    let measurementType: String?
    let presetVersion: String?
    let temperature: Double?
    let tempUnits: String?
    let responseLoudspeakerBrand: String?
    let coherenceScale: String?
    let analyzer: String?
    let fileTFNative: String?
    let splGroundPlane: Bool?
    let responseLoudspeakerModel: String?
    let systemLatency: Double?
    let microphone: String?
    let measurement: String?
    let interface: String?
    let micCorrectionCurve: String?
    let tfJSONFrequency: String?
    let tfJSONMagnitude: String?
    let tfJSONPhase: String?
    let tfJSONCoherence: String?
    let id: String
    let medal: String?
    let fileIRWAV: String?
    let windscreen: String?
    let presetNA: Bool?
    let presetVersionNA: Bool?
    let firmwareVersionNA: Bool?
    let inputMeter: Double?

    enum CodingKeys: String, CodingKey {
        case firmwareVersion = "Firmware Version"
        case loudspeakerBrand = "Loudspeaker Brand"
        case category = "Category"
        case delayLocator = "Delay Locator"
        case distance = "Distance"
        case dspPreset = "DSP Preset"
        case photoSetup = "Photo setup"
        case fileAdditional = "File additional"
        case fileTFCSV = "File TF CSV"
        case notes = "Notes"
        case createdDate = "Created Date"
        case createdBy = "Created By"
        case modifiedDate = "Modified Date"
        case distanceUnits = "Distance Units"
        case crestFactorM = "Crest Factor m"
        case crestFactorPink = "Crest Factor pink"
        case loudspeakerModel = "Loudspeaker Model"
        case calibrator = "Calibrator"
        case measurementType = "Measurement Type"
        case presetVersion = "Preset Version"
        case temperature = "Temperature"
        case tempUnits = "Temp Units"
        case responseLoudspeakerBrand = "_Loudspeaker Brand"
        case coherenceScale = "Coherence Scale"
        case analyzer = "_Analyzer"
        case fileTFNative = "File TF native"
        case splGroundPlane = "SPL ground-plane"
        case responseLoudspeakerModel = "_Loudspeaker Model"
        case systemLatency = "System latency"
        case microphone = "_Microphone"
        case measurement = "_Measurement"
        case interface = "_Interface"
        case micCorrectionCurve = "Mic Correction Curve"
        case tfJSONFrequency = "TF JSON frequency"
        case tfJSONMagnitude = "TF JSON magnitude"
        case tfJSONPhase = "TF JSON phase"
        case tfJSONCoherence = "TF JSON coherence"
        case id = "_id"
        case medal = "Medal"
        case fileIRWAV =  "File IR WAV"
        case windscreen =  "Windscreen"
        case presetNA = "Preset NA"
        case presetVersionNA = "Preset Version NA"
        case firmwareVersionNA = "Firmware Version NA"
        case inputMeter = "Input Meter"
    }
}
