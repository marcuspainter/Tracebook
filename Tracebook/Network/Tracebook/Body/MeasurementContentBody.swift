//
//  MeasurementContentBody.swift
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
    var firmwareVersion: String?
    var loudspeakerBrand: String?
    var category: String?
    var delayLocator: Double?
    var distance: Double?
    var dspPreset: String?
    var photoSetup: String?
    var fileAdditional: [String]?
    var fileTFCSV: String?
    var notes: String?
    var createdDate: String?
    var createdBy: String?
    var modifiedDate: String?
    var distanceUnits: String?
    var crestFactorM: Double?
    var crestFactorPink: Double?
    var loudspeakerModel: String?
    var calibrator: String?
    var measurementType: String?
    var presetVersion: String?
    var temperature: Double?
    var tempUnits: String?
    var responseLoudspeakerBrand: String?
    var coherenceScale: String?
    var analyzer: String?
    var fileTFNative: String?
    var splGroundPlane: Bool?
    var responseLoudspeakerModel: String?
    var systemLatency: Double?
    var microphone: String?
    var measurement: String?
    var interface: String?
    var interfaceBrandModel: String?
    var micCorrectionCurve: String?
    var tfJSONFrequency: String?
    var tfJSONMagnitude: String?
    var tfJSONPhase: String?
    var tfJSONCoherence: String?
    var medal: String?
    var fileIRWAV: String?
    var windscreen: String?
    var presetNA: Bool?
    var presetVersionNA: Bool?
    var firmwareVersionNA: Bool?
    var inputMeter: Double?

    var microphoneText: String = ""
    var interfaceText: String = ""
    var analyzerText: String = ""
    var tfFrequency: [Double] = []
    var tfMagnitude: [Double] = []
    var tfPhase: [Double] = []
    var tfCoherence: [Double] = []

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
        case interfaceBrandModel = "Interface Brand+Model"
        case micCorrectionCurve = "Mic Correction Curve"
        case tfJSONFrequency = "TF JSON frequency"
        case tfJSONMagnitude = "TF JSON magnitude"
        case tfJSONPhase = "TF JSON phase"
        case tfJSONCoherence = "TF JSON coherence"
        case id = "_id"
        case medal = "Medal"
        case fileIRWAV = "File IR WAV"
        case windscreen = "Windscreen"
        case presetNA = "Preset NA"
        case presetVersionNA = "Preset Version NA"
        case firmwareVersionNA = "Firmware Version NA"
        case inputMeter = "Input Meter"
    }

    func processMagnitude(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newMagnitudeData = tfFrequency.enumerated().map { index, frequency in
            guard index < self.tfMagnitude.count else { return (frequency, Double.nan) }
            let magnitude = self.tfMagnitude[index]

            if index < self.tfCoherence.count {
                let coherence = self.tfCoherence[index]
                if coherence < threshold {
                    return (frequency, Double.nan)
                }
            }
            return (frequency, magnitude)
        }
        return newMagnitudeData
    }

    func processPhase(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newPhaseData = tfFrequency.enumerated().map { index, frequency in
            guard index < self.tfPhase.count else { return (frequency, Double.nan) }
            var phase = self.tfPhase[index]

            if index < self.tfCoherence.count {
                let coherence = self.tfCoherence[index]
                if coherence < threshold {
                    return (frequency, Double.nan)
                }
            }
            phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
            if isPolarityInverted {
                phase += 180.0
            }
            phase = wrapTo180(phase)
            return (frequency, phase)
        }
        return newPhaseData
    }

    func processCoherence(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newCoherenceData = tfFrequency.enumerated().map { index, frequency in
            guard index < self.tfCoherence.count else { return (frequency, Double.nan) }
            let coherence = self.tfCoherence[index]

            if coherence < threshold {
                return (frequency, Double.nan)
            }
            return (frequency, coherence / 3.333) // Scale to fit graph axis at 30dB = 100%
        }
        return newCoherenceData
    }

    private func wrapTo180(_ phase: Double) -> Double {
        var newPhase = (phase + 180.0).truncatingRemainder(dividingBy: 360.0)
        if newPhase < 0.0 {
            newPhase += 360.0
        }
        return newPhase - 180.0
    }
}
