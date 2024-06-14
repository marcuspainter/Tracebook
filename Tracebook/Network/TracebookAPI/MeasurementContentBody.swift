//
//  MeasurementContent.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct MeasurementContentBody: Codable, Sendable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MeasurementContentBody, rhs: MeasurementContentBody) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let analyzer: String?
    let calibrator: String?
    let category: String?
    let coherenceScale: String?
    let createdBy: String?
    let createdDate: String?
    let crestFactorM: Double?
    let crestFactorPink: Double?
    let delayLocator: Double?
    let distance: Double?
    let distanceUnits: String?
    let dspPreset: String?
    let fileAdditional: [String]?
    let fileIRWAV: String?
    let fileTFCSV: String?
    let fileTFNative: String?
    let firmwareVersion: String?
    let firmwareVersionNA: Bool?
    // id
    let interface: String?
    let inputMeter: Double?
    let loudspeakerBrand: String?
    let loudspeakerModel: String?
    let measurement: String?
    let measurementType: String?
    let medal: String?
    let micCorrectionCurve: String?
    let microphone: String?
    let modifiedDate: String?
    let notes: String?
    let photoSetup: String?
    let presetNA: Bool?
    let presetVersion: String?
    let presetVersionNA: Bool?
    let responseLoudspeakerBrand: String?
    let responseLoudspeakerModel: String?
    let splGroundPlane: Bool?
    let systemLatency: Double?
    let temperature: Double?
    let tempUnits: String?
    let tfJSONCoherence: String?
    let tfJSONFrequency: String?
    let tfJSONMagnitude: String?
    let tfJSONPhase: String?
    let windscreen: String?
    
    // Computed
    let microphoneText: String = ""
    let interfaceText: String = ""
    let analyzerText: String = ""
    let tfFrequency: [Double] = []
    let tfMagnitude: [Double] = []
    let tfPhase: [Double] = []
    let tfCoherence: [Double] = []
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case analyzer = "_Analyzer"
        case calibrator = "Calibrator"
        case category = "Category"
        case coherenceScale = "Coherence Scale"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case crestFactorM = "Crest Factor m"
        case crestFactorPink = "Crest Factor pink"
        case delayLocator = "Delay Locator"
        case distance = "Distance"
        case distanceUnits = "Distance Units"
        case dspPreset = "DSP Preset"
        case fileAdditional = "File additional"
        case fileIRWAV = "File IR WAV"
        case fileTFCSV = "File TF CSV"
        case fileTFNative = "File TF native"
        case firmwareVersion = "Firmware Version"
        case firmwareVersionNA = "Firmware Version NA"
        // id
        case inputMeter = "Input Meter"
        case interface = "_Interface"
        case loudspeakerBrand = "Loudspeaker Brand"
        case loudspeakerModel = "Loudspeaker Model"
        case measurement = "_Measurement"
        case measurementType = "Measurement Type"
        case medal = "Medal"
        case micCorrectionCurve = "Mic Correction Curve"
        case microphone = "_Microphone"
        case modifiedDate = "Modified Date"
        case notes = "Notes"
        case photoSetup = "Photo setup"
        case presetNA = "Preset NA"
        case presetVersion = "Preset Version"
        case presetVersionNA = "Preset Version NA"
        case responseLoudspeakerBrand = "_Loudspeaker Brand"
        case responseLoudspeakerModel = "_Loudspeaker Model"
        case splGroundPlane = "SPL ground-plane"
        case systemLatency = "System latency"
        case temperature = "Temperature"
        case tempUnits = "Temp Units"
        case tfJSONCoherence = "TF JSON coherence"
        case tfJSONFrequency = "TF JSON frequency"
        case tfJSONMagnitude = "TF JSON magnitude"
        case tfJSONPhase = "TF JSON phase"
        case windscreen = "Windscreen"
    }
    
}
