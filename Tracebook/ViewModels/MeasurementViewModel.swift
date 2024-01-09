//
//  MesurementViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 18/12/2023.
//

import Foundation

@MainActor
class MeasurementViewModel: ObservableObject {
    
    @Published var isPolarityInverted: Bool = false
    @Published var delay: Double = 0.0
    @Published var threshold: Double = 0.0

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
    @Published var microphone: String = ""
    var measurement: String = ""
    var interface: String = ""
    var micCorrectionCurve: String = ""
    var tfFrequency: [Double] = []
    var tfMagnitude: [Double] = []
    var tfPhase: [Double] = []
    var tfCoherence: [Double] = []
    var id: String = ""
    
    @Published var magitudeData: [(Double, Double)] = []
    @Published var phaseData: [(Double, Double)] = []
    @Published var coherenceData: [(Double, Double)] = []
    @Published var originalPhaseData: [(Double, Double)] = []
    
    func processMagnitude(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newMagnitudeData = self.tfMagnitude.enumerated().map {
            let index = $0
            let f = self.tfFrequency[index]
            let c = self.tfCoherence[index]
            let m = $1
            if c < threshold {
                return (f, Double.nan)
            } else {
                return (f, m)
            }
        }
        return newMagnitudeData
    }

    func processPhase(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {

        let newPhaseData = self.tfPhase.enumerated().map {
            let index = $0
            let f = self.tfFrequency[index]
            let c = self.tfCoherence[index]
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

    func processCoherence(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [(Double, Double)] {
        let newCoherenceData = self.tfCoherence.enumerated().map {
            let index = $0
            let f = self.tfFrequency[index]
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
