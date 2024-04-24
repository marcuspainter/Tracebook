//
//  MeasurementProcessor.swift
//  Tracebook
//
//  Created by Marcus Painter on 22/04/2024.
//

import Foundation

struct TracebookProcessor {

    static func processMagnitude(tfFrequency: [Double], tfMagnitude: [Double], tfCoherence: [Double],
                              threshold: Double) -> [Double] {
        guard threshold > 0.0 else { return tfMagnitude }
        
        let newMagnitudeData = tfFrequency.enumerated().map { index, frequency in
            guard index < tfMagnitude.count else { return Double.nan }
            let magnitude = tfMagnitude[index]

            if index < tfCoherence.count {
                let coherence = tfCoherence[index]
                if coherence < threshold/100 {
                    return Double.nan
                }
            }
            return magnitude
        }
        return newMagnitudeData
    }

    static func processPhase(tfFrequency: [Double], tfPhase: [Double], tfCoherence: [Double],
                            threshold: Double, delay: Double, isPolarityInverted: Bool) -> [Double] {
        //guard !(threshold == 0.0 && delay == 0.0 && !isPolarityInverted) else { return tfPhase }
                
        let newPhaseData = tfFrequency.enumerated().map { index, frequency in
            guard index < tfPhase.count else { return Double.nan }
            var phase = tfPhase[index]

            if index < tfCoherence.count {
                let coherence = tfCoherence[index]
                if coherence < threshold/100 {
                    return Double.nan
                }
            }

            phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
            if isPolarityInverted {
                phase += 180.0
            }
            phase = TracebookProcessor.wrapTo180(phase)
            return phase
        }
        return newPhaseData
    }

    static func processCoherence(tfFrequency: [Double], tfCoherence: [Double],
                                 threshold: Double) -> [Double] {
        guard threshold > 0.0 else { return tfCoherence }
        
        let newCoherenceData = tfFrequency.enumerated().map { index, frequency in
            guard index < tfCoherence.count else { return Double.nan }

            let coherence = tfCoherence[index]
            if coherence < threshold/100 {
                return Double.nan
            }
            return coherence
        }
        return newCoherenceData
    }

    static func wrapTo180(_ phase: Double) -> Double {
        guard phase > 180.0 || phase < -180 else { return phase }
        
        var newPhase = (phase + 180.0).truncatingRemainder(dividingBy: 360.0)
        if newPhase < 0.0 {
            newPhase += 360.0
        }
        return newPhase - 180.0
    }

}
