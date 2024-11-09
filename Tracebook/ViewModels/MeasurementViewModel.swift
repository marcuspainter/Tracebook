//
//  MesurementViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 18/12/2023.
//

import Foundation

@MainActor
class MeasurementViewModel {

    var isPolarityInverted: Bool = false
    var delay: Double = 0.0
    var threshold: Double = 0.0

    var firmwareVersion: String = ""
    var loudspeakerBrand: String = ""
    var category: String = ""
    var delayLocator: Double = 0.0
    var distance: Double = 0.0
    var dspPreset: String = ""
    var photoSetup: String = ""
    var fileAdditional: [String] = []
    var fileTFCSV: String = ""
    var notes: String = ""
    var createdDate: String = ""
    var createdBy: String = ""
    var modifiedDate: String = ""
    var distanceUnits: String = ""
    var crestFactorM: Double = 0.0
    var crestFactorPink: Double = 0.0
    var loudspeakerModel: String = ""
    var calibrator: String = ""
    var measurementType: String = ""
    var presetVersion: String = ""
    var temperature: Double = 0.0
    var tempUnits: String = ""
    var responseLoudspeakerBrand: String = ""
    var coherenceScale: String = ""
    var analyzer: String = ""
    var fileTFNative: String = ""
    var splGroundPlane: Bool = false
    var responseLoudspeakerModel: String = ""
    var systemLatency: Double = 0.0
    var microphone: String = ""
    var measurement: String = ""
    var interface: String = ""
    var micCorrectionCurve: String = ""
    var tfFrequency: [Double] = []
    var tfMagnitude: [Double] = []
    var tfPhase: [Double] = []
    var tfCoherence: [Double] = []
    var id: String = ""
    var medal: String = ""
    var windscreen: String = ""

    var magitudeData: [(Double, Double)] = []
    var phaseData: [(Double, Double)] = []
    var coherenceData: [(Double, Double)] = []
    var originalPhaseData: [(Double, Double)] = []

    func processMagnitude(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newMagnitudeData = self.tfFrequency.enumerated().map { index, frequency in
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
        let newPhaseData = self.tfFrequency.enumerated().map { index, frequency in
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
        let newCoherenceData = self.tfFrequency.enumerated().map { index, frequency in
            guard index < self.tfCoherence.count else { return (frequency, Double.nan) }

            let coherence = self.tfCoherence[index]
            if coherence < threshold {
                return (frequency, Double.nan)
            }
            return (frequency, (coherence / 2.0))
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
