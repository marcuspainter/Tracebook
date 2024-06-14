//
//  MeasurementContent.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

class MeasurementContentBody: Codable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MeasurementContentBody, rhs: MeasurementContentBody) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = ""
    var analyzer: String?
    var calibrator: String?
    var category: String?
    var coherenceScale: String?
    var createdBy: String?
    var createdDate: String?
    var crestFactorM: Double?
    var crestFactorPink: Double?
    var delayLocator: Double?
    var distance: Double?
    var distanceUnits: String?
    var dspPreset: String?
    var fileAdditional: [String]?
    var fileIRWAV: String?
    var fileTFCSV: String?
    var fileTFNative: String?
    var firmwareVersion: String?
    var firmwareVersionNA: Bool?
    // id
    var interface: String?
    var inputMeter: Double?
    var loudspeakerBrand: String?
    var loudspeakerModel: String?
    var measurement: String?
    var measurementType: String?
    var medal: String?
    var micCorrectionCurve: String?
    var microphone: String?
    var modifiedDate: String?
    var notes: String?
    var photoSetup: String?
    var presetNA: Bool?
    var presetVersion: String?
    var presetVersionNA: Bool?
    var responseLoudspeakerBrand: String?
    var responseLoudspeakerModel: String?
    var splGroundPlane: Bool?
    var systemLatency: Double?
    var temperature: Double?
    var tempUnits: String?
    var tfJSONCoherence: String?
    var tfJSONFrequency: String?
    var tfJSONMagnitude: String?
    var tfJSONPhase: String?
    var windscreen: String?
    
    // Computed
    var microphoneText: String = ""
    var interfaceText: String = ""
    var analyzerText: String = ""
    var tfFrequency: [Double] = []
    var tfMagnitude: [Double] = []
    var tfPhase: [Double] = []
    var tfCoherence: [Double] = []
    
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
