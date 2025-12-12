//
//  DataProcessor.swift
//  TracebookDB
//
//  Created by Marcus Painter on 23/07/2025.
//

import Foundation

@Observable
class MeasurementProcessor {
    
    var frequency: [Double] = []
    var magnitude: [Double] = []
    var phase: [Double] = []
    var coherence: [Double] = []
    var originalPhase: [Double] = []
    
    private var tfFrequency: [Double] = []
    private var tfMagnitude: [Double] = []
    private var tfPhase: [Double] = []
    private var tfCoherence: [Double] = []
    
    init(frequency: [Double], magnitude: [Double], phase: [Double], coherence: [Double]) {
        self.tfFrequency = frequency
        self.tfMagnitude = magnitude
        self.tfPhase = phase
        self.tfCoherence = coherence
        
        reset()
    }
    
    func processInvert(delay: Double, threshold: Double, isPolarityInverted: Bool) {
    }
    
    func processThreshold(delay: Double, threshold: Double, isPolarityInverted: Bool) {
    }
    
    func processDelay(delay: Double, threshold: Double, isPolarityInverted: Bool) {
    }
    
    func processAll(delay: Double, threshold: Double, isPolarityInverted: Bool) {
        let count = tfFrequency.count
        var newCoherence = [Double](repeating: 0, count: count)
        var newMagnitude = [Double](repeating: 0, count: count)
        var newPhase = [Double](repeating: 0, count: count)
        var newOriginalPhase = [Double](repeating: 0, count:count)

        for index in 0..<frequency.count {
            newCoherence[index] = index < tfCoherence.count ? tfCoherence[index] : Double.nan
            newMagnitude[index] = index < tfMagnitude.count ? tfMagnitude[index] : Double.nan
            newPhase[index] =  index < tfPhase.count ? tfPhase[index] : Double.nan
            newOriginalPhase[index] = index < tfPhase.count ? tfPhase[index] : Double.nan

            if index < tfCoherence.count {
                let coherence = tfCoherence[index]
                
                if coherence < threshold {
                    newCoherence[index] = Double.nan
                    newMagnitude[index] =  Double.nan
                    newPhase[index] = Double.nan
                    newOriginalPhase[index] = Double.nan
                } else {
                    let frequency = index < tfFrequency.count ? tfFrequency[index] : Double.nan
                    var phase = index < tfPhase.count ? tfPhase[index] : Double.nan
                    phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
                    if isPolarityInverted {
                        phase += 180.0
                    }
                    newPhase[index] = wrapTo180(phase)
                }
           }
        }
        self.magnitude = newMagnitude
        self.phase = newPhase
        self.coherence = newCoherence
        self.originalPhase = newOriginalPhase
        return
    }
    
    func reset() {
        self.frequency = tfFrequency
        self.magnitude = tfMagnitude
        self.phase = tfPhase
        self.coherence = tfCoherence
        self.originalPhase = tfPhase
    }
    
    private func wrapTo180(_ phase: Double) -> Double {
        var newPhase = (phase + 180.0).truncatingRemainder(dividingBy: 360.0)
        if newPhase < 0.0 {
            newPhase += 360.0
        }
        return newPhase - 180.0
    }
}
