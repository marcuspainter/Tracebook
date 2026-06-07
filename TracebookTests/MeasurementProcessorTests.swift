//
//  MeasurementProcessorTests.swift
//  TracebookTests
//
//  Created by Codex on 07/06/2026.
//

import Testing
@testable import Tracebook

@Suite
struct MeasurementProcessorTests {

    @Test
    func testResetPreservesOriginalPhaseAndData() {
        let processor = makeProcessor(
            frequency: [100.0, 1_000.0],
            magnitude: [1.0, 2.0],
            phase: [45.0, -90.0],
            coherence: [0.9, 0.8]
        )

        #expect(processor.frequency == [100.0, 1_000.0])
        #expect(processor.magnitude == [1.0, 2.0])
        #expect(processor.phase == [45.0, -90.0])
        #expect(processor.originalPhase == [45.0, -90.0])
        #expect(processor.coherence == [0.9, 0.8])
    }

    @Test
    func testPositiveDelaySubtractsPhaseByFrequency() {
        let processor = makeProcessor(
            frequency: [500.0, 1_000.0],
            magnitude: [1.0, 1.0],
            phase: [0.0, 90.0],
            coherence: [1.0, 1.0]
        )

        processor.processAll(delay: 1.0, threshold: 0.0, isPolarityInverted: false)

        assertEqual(processor.phase[0], -180.0)
        assertEqual(processor.phase[1], 90.0)
    }

    @Test
    func testNegativeDelayAddsPhaseByFrequency() {
        let processor = makeProcessor(
            frequency: [250.0, 500.0],
            magnitude: [1.0, 1.0],
            phase: [0.0, -90.0],
            coherence: [1.0, 1.0]
        )

        processor.processAll(delay: -1.0, threshold: 0.0, isPolarityInverted: false)

        assertEqual(processor.phase[0], 90.0)
        assertEqual(processor.phase[1], 90.0)
    }

    @Test
    func testPolarityInversionAdds180DegreesAndWraps() {
        let processor = makeProcessor(
            frequency: [100.0, 100.0],
            magnitude: [1.0, 1.0],
            phase: [0.0, 90.0],
            coherence: [1.0, 1.0]
        )

        processor.processAll(delay: 0.0, threshold: 0.0, isPolarityInverted: true)

        assertEqual(processor.phase[0], -180.0)
        assertEqual(processor.phase[1], -90.0)
    }

    @Test
    func testDelayAndPolarityCombineBeforeWrapping() {
        let processor = makeProcessor(
            frequency: [500.0],
            magnitude: [1.0],
            phase: [0.0],
            coherence: [1.0]
        )

        processor.processAll(delay: 1.0, threshold: 0.0, isPolarityInverted: true)

        assertEqual(processor.phase[0], 0.0)
    }

    @Test
    func testPhaseOnlyProcessingDoesNotRepublishMagnitudeCoherenceOrOriginalPhase() {
        let processor = makeProcessor(
            frequency: [500.0, 1_000.0],
            magnitude: [10.0, 20.0],
            phase: [0.0, 90.0],
            coherence: [0.4, 0.8]
        )

        processor.processAll(delay: 0.0, threshold: 0.5, isPolarityInverted: false)

        let magnitude = processor.magnitude
        let coherence = processor.coherence
        let originalPhase = processor.originalPhase

        processor.processPhase(delay: 1.0, threshold: 0.5, isPolarityInverted: true)

        #expect(processor.magnitude.elementsEqual(magnitude, by: valuesMatch))
        #expect(processor.coherence.elementsEqual(coherence, by: valuesMatch))
        #expect(processor.originalPhase.elementsEqual(originalPhase, by: valuesMatch))
        #expect(processor.phase[0].isNaN)
        assertEqual(processor.phase[1], -90.0)
    }

    @Test
    func testCoherenceBelowThresholdFiltersAllSeriesAtThatPoint() {
        let processor = makeProcessor(
            frequency: [100.0, 200.0],
            magnitude: [10.0, 20.0],
            phase: [30.0, 60.0],
            coherence: [0.4, 0.8]
        )

        processor.processAll(delay: 0.0, threshold: 0.5, isPolarityInverted: false)

        #expect(processor.coherence[0].isNaN)
        #expect(processor.magnitude[0].isNaN)
        #expect(processor.phase[0].isNaN)
        #expect(processor.originalPhase[0].isNaN)

        assertEqual(processor.coherence[1], 0.8)
        assertEqual(processor.magnitude[1], 20.0)
        assertEqual(processor.phase[1], 60.0)
        assertEqual(processor.originalPhase[1], 60.0)
    }

    @Test
    func testCoherenceEqualToThresholdIsKept() {
        let processor = makeProcessor(
            frequency: [100.0],
            magnitude: [10.0],
            phase: [30.0],
            coherence: [0.5]
        )

        processor.processAll(delay: 0.0, threshold: 0.5, isPolarityInverted: false)

        assertEqual(processor.coherence[0], 0.5)
        assertEqual(processor.magnitude[0], 10.0)
        assertEqual(processor.phase[0], 30.0)
    }

    private func makeProcessor(
        frequency: [Double],
        magnitude: [Double],
        phase: [Double],
        coherence: [Double]
    ) -> MeasurementProcessor {
        MeasurementProcessor(
            frequency: frequency,
            magnitude: magnitude,
            phase: phase,
            coherence: coherence
        )
    }

    private func assertEqual(
        _ actual: Double,
        _ expected: Double,
        accuracy: Double = 0.000_001,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(abs(actual - expected) <= accuracy, sourceLocation: sourceLocation)
    }

    private func valuesMatch(_ lhs: Double, _ rhs: Double) -> Bool {
        if lhs.isNaN && rhs.isNaN {
            return true
        }
        return lhs == rhs
    }
}
