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
    }

    static func == (lhs: MeasurementModel, rhs: MeasurementModel) -> Bool {
        return lhs.id == rhs.id
    }

    // Measurement Content
    var firmwareVersion: String = ""
    var loudspeakerBrand: String = ""
    var category: String = ""
    var delayLocator: Double?       // Nilable
    var distance: Double?           // Nilable
    var dspPreset: String = ""
    var photoSetup: String = ""
    var fileAdditional: [String] = []
    var fileTFCSV: String = ""
    var notes: String = ""
    var createdDate: String? = ""
    var createdBy: String = ""
    var modifiedDate: String = ""
    var distanceUnits: String = ""
    var crestFactorM: Double = 0.0
    var crestFactorPink: Double = 0.0
    var loudspeakerModel: String = ""
    var calibrator: String = ""
    var measurementType: String = ""
    var presetVersion: String = ""
    var temperature: Double?       // Nilable
    var tempUnits: String = ""
    var responseLoudspeakerBrand: String = ""
    var coherenceScale: String = ""
    var analyzer: String = ""
    var fileTFNative: String = ""
    var splGroundPlane: Bool = false
    var responseLoudspeakerModel: String = ""
    var systemLatency: Double?      // Nilable
    @Published var microphone: String = ""
    var measurement: String = ""
    var interface: String = ""
    var micCorrectionCurve: String = ""
    var tfFrequency: [Double] = []
    var tfMagnitude: [Double] = []
    var tfPhase: [Double] = []
    var tfCoherence: [Double] = []
    var id: String = ""
    var medal: String? = ""
    var fileIRWAV: String? = ""
    var windscreen: String = ""
    var presetNA: Bool? = false
    var presetVersionNA: Bool? = false
    var firmwareVersionNA: Bool? = false
    var inputMeter: Double? = 0.0

    // Measurement
    var additionalContent: String = ""
    var approved: String = ""
    var commentCreator: String? = ""
    var productLaunchDateText: String = ""
    var thumbnailImage: String? = ""
    var upvotes: [String]? = []
    // var createdDate: String = ""
    // var createdBy: String = ""
    // var modifiedDate: String = ""
    var slug: String = ""
    var moderator1: String = ""
    var isPublic: Bool = false
    var title: String = ""
    var publishDate: String? = ""
    var admin1Approved: String? = ""
    var moderator2: String? = ""
    var admin2Approved: String? = ""
    // var id: String = ""
    var loudspeakerTags: [String]? = []
    var emailSent: Bool? = false

    // Generated from slug
    var tracebookURL: String = ""

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
            newCoherence[index] = index < self.tfCoherence.count ? self.tfCoherence[index]  / 3.333 : Double.nan// Scaling for chart
            newMagnitude[index] = index < self.tfMagnitude.count ? self.tfMagnitude[index] : Double.nan
            newPhase[index] =  index < self.tfPhase.count ? self.tfPhase[index] : Double.nan
            newOriginalPhase[index] = index < self.tfPhase.count ? self.tfPhase[index] : Double.nan

            if index < self.tfCoherence.count {
                let coherence = self.tfCoherence[index]
                
                if coherence < threshold {
                    newCoherence[index] = Double.nan
                    newMagnitude[index] =  Double.nan
                    newPhase[index] = Double.nan
                    newOriginalPhase[index] = Double.nan
                } else {
                    let frequency = index < self.tfFrequency.count ? self.tfFrequency[index] : Double.nan
                    var phase = index < self.tfPhase.count ? self.tfPhase[index] : Double.nan
                    phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
                    if isPolarityInverted {
                        phase += 180.0
                    }
                    newPhase[index] = wrapTo180(phase)
                }
           }
        }
        return (newMagnitude, newPhase, newCoherence, newOriginalPhase)
    }
}
