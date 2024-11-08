//
//  MeasurementModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 18/12/2023.
//

import Foundation

final class MeasurementModel: ObservableObject, Identifiable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timestamp)
    }

    static func == (lhs: MeasurementModel, rhs: MeasurementModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Published var timestamp: Date = .now

    // Measurement Content
    @Published var firmwareVersion: String = ""
    @Published var loudspeakerBrand: String = ""
    @Published var category: String = ""
    @Published var delayLocator: Double?       // Nilable
    @Published var distance: Double?           // Nilable
    @Published var dspPreset: String = ""
    @Published var photoSetup: String = ""
    @Published var fileAdditional: [String] = []
    @Published var fileTFCSV: String = ""
    @Published var notes: String = ""
    @Published var createdDate: String? = ""
    @Published var createdBy: String = ""
    @Published var modifiedDate: String = ""
    @Published var distanceUnits: String = ""
    @Published var crestFactorM: Double = 0.0
    @Published var crestFactorPink: Double = 0.0
    @Published var loudspeakerModel: String = ""
    @Published var calibrator: String = ""
    @Published var measurementType: String = ""
    @Published var presetVersion: String = ""
    @Published var temperature: Double?       // Nilable
    @Published var tempUnits: String = ""
    @Published var responseLoudspeakerBrand: String = ""
    @Published var coherenceScale: String = ""
    @Published var analyzer: String = ""
    @Published var fileTFNative: String = ""
    @Published var splGroundPlane: Bool = false
    @Published var responseLoudspeakerModel: String = ""
    @Published var systemLatency: Double?      // Nilable
    @Published var microphone: String = ""
    @Published var measurement: String = ""
    @Published var interface: String = ""
    @Published var micCorrectionCurve: String = ""
    @Published var tfFrequency: [Double] = []
    @Published var tfMagnitude: [Double] = []
    @Published var tfPhase: [Double] = []
    @Published var tfCoherence: [Double] = []
    @Published var id: String = ""
    @Published var medal: String? = ""
    @Published var fileIRWAV: String? = ""
    @Published var windscreen: String = ""
    @Published var presetNA: Bool? = false
    @Published var presetVersionNA: Bool? = false
    @Published var firmwareVersionNA: Bool? = false
    @Published var inputMeter: Double? = 0.0

    // Measurement
    @Published var additionalContent: String = ""
    @Published var approved: String = ""
    @Published var commentCreator: String? = ""
    @Published var productLaunchDateText: String = ""
    @Published var thumbnailImage: String? = ""
    @Published var upvotes: [String]? = []
    // var createdDate: String = ""
    // var createdBy: String = ""
    // var modifiedDate: String = ""
    @Published var slug: String = ""
    @Published var moderator1: String = ""
    @Published var isPublic: Bool = false
    @Published var title: String = ""
    @Published var publishDate: String? = ""
    @Published var admin1Approved: String? = ""
    @Published var moderator2: String? = ""
    @Published var admin2Approved: String? = ""
    // var id: String = ""
    @Published var loudspeakerTags: [String]? = []
    @Published var emailSent: Bool? = false

    // Generated from slug
    @Published var tracebookURL: String = ""

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
            return (frequency, (coherence / 3.333)) // Scale to fit graph axis at 30dB = 100%
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

    func processMagnitude2(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [Double] {

        let newMagnitudeData = self.tfMagnitude.enumerated().map { index, magnitude in
            guard index < self.tfCoherence.count else { return Double.nan }

            let coherence = self.tfCoherence[index]
            if coherence < threshold {
                return Double.nan
            }

            return magnitude
        }
        return newMagnitudeData
    }

    func processPhase2(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [Double] {

        let newPhaseData = self.tfPhase.enumerated().map { index, phase in
            guard index < self.tfFrequency.count else { return Double.nan }
            guard index < self.tfCoherence.count else { return Double.nan }

                let coherence = self.tfCoherence[index]
                if coherence < threshold {
                    return Double.nan
                }
                let frequency = self.tfFrequency[index]
                var newPhase = phase + (frequency * 360.0 * (delay * -1.0 / 1000.0))
                if isPolarityInverted {
                    newPhase += 180.0
                }
                newPhase = wrapTo180(newPhase)
                return newPhase
        }
        return newPhaseData
    }

    func processCoherence2(delay: Double, threshold: Double, isPolarityInverted: Bool) -> [Double] {
        let newCoherenceData = self.tfCoherence.enumerated().map { _, coherence in

            if coherence < threshold {
                return Double.nan
            }
            return coherence / 3.333 // Scale to fit graph axis at 30dB = 100%
        }
        return newCoherenceData
    }

    func processAll2(delay: Double, threshold: Double, isPolarityInverted: Bool) ->
    (magnitude: [Double], phase: [Double], coherence: [Double], originalPhase: [Double]) {

        var newCoherence = [Double](repeating: 0, count: tfFrequency.count)
        var newMagnitude = [Double](repeating: 0, count: tfFrequency.count)
        var newPhase = [Double](repeating: 0, count: tfFrequency.count)
        var newOriginalPhase = [Double](repeating: 0, count: tfFrequency.count)

        for index in 0..<tfFrequency.count {
            newCoherence[index] = self.tfCoherence[index]  / 3.333 // Scaling for chart
            newMagnitude[index] = self.tfMagnitude[index]
            newPhase[index] = self.tfPhase[index]
            newOriginalPhase[index] = self.tfPhase[index]

            let coherence = self.tfCoherence[index]
            if coherence < threshold {
                newCoherence[index] = Double.nan
                newMagnitude[index] =  Double.nan
                newPhase[index] = Double.nan
                newOriginalPhase[index] = Double.nan
            } else {
                let frequency = self.tfFrequency[index]
                var phase = self.tfPhase[index]
                phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
                if isPolarityInverted {
                    phase += 180.0
                }
                newPhase[index] = wrapTo180(phase)
            }
        }
        return (newMagnitude, newPhase, newCoherence, newOriginalPhase)
    }
}
