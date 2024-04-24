//
//  PhaseChart.swift
//  Tracebook
//
//  Created by Marcus Painter on 24/04/2024.
//

import Foundation
import SwiftUI
import Charts

struct PhaseChart: View {
    let frequencyData: [Double]
    let phaseData: [Double]
    let originalPhaseData: [Double]

    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]
    private let phaseYAxisValues = [-180, -135, -90, -45, 0, 45, 90, 135, 180]
    
    init(frequencyData: [Double], phaseData: [Double], coherenceData: [Double], threshold: Double, delay: Double,
         isPolarityInverted: Bool) {

        self.frequencyData = frequencyData
        
        self.phaseData = TracebookProcessor.processPhase(
            tfFrequency: frequencyData,
            tfPhase: phaseData,
            tfCoherence: coherenceData,
            threshold: threshold,
            delay: delay,
            isPolarityInverted: isPolarityInverted
            )
  
        self.originalPhaseData = TracebookProcessor.processPhase(
            tfFrequency: frequencyData,
            tfPhase: phaseData,
            tfCoherence: coherenceData,
            threshold: threshold,
            delay: 0.0,
            isPolarityInverted: false
            )
    }

    var body: some View {
        Group {
            Text("Phase")
            Chart {
                ForEach(frequencyData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("x", frequencyData[index]),
                        y: .value("y", index < originalPhaseData.count ? originalPhaseData[index] : Double.nan),
                        series: .value("Weight", "A")
                    )
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(frequencyData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("x", frequencyData[index]),
                        y: .value("y", index < phaseData.count ? phaseData[index] : Double.nan),
                        series: .value("Weight", "B")
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }
            }
            .chartXAxis {
                AxisMarks(values: frequencyXAxisValues) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            let textValue = intValue < 999 ? "\(intValue)" : "\(intValue / 1000)k"
                            Text(textValue)
                                .font(.caption2)
                        }
                    }
                }
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Frequency (Hz)")
            }
            .chartXScale(domain: 20 ... 20000, type: .log)
            .chartYAxis {
                AxisMarks(position: .leading, values: phaseYAxisValues) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)")
                        }
                    }
                }
            }
            .chartYAxisLabel(position: .trailing, alignment: .center) {
                Text("Phase (°)")
            }
            .chartYScale(domain: -200 ... 200, type: .linear
            )
            .clipped()
            .frame(height: 200)
        }
    }
}
