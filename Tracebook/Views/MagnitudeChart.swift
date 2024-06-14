//
//  TraceDetailView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI
import Charts

struct MagnitudeChart: View {
    let frequencyData: [Double]
    let magnitudeData: [Double]
    let coherenceData: [Double]

    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]
    
    init(frequencyData: [Double], magnitudeData: [Double], coherenceData: [Double], threshold: Double) {
        self.frequencyData = frequencyData
        
        self.magnitudeData = TracebookProcessor.processMagnitude(
            tfFrequency: frequencyData,
            tfMagnitude: magnitudeData,
            tfCoherence: coherenceData,
            threshold: threshold)
        
        let rawCoherence =  TracebookProcessor.processCoherence(
            tfFrequency: frequencyData,
            tfCoherence: coherenceData,
            threshold: threshold)
        let scaledCoherence = rawCoherence.map { $0 * 100 / 3.3333 } // Scale for chart
        self.coherenceData = scaledCoherence

    }

    var body: some View {
        Group {
            Text("Magnitude")
            Chart {
                ForEach(frequencyData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Frequency", frequencyData[index]),
                        y: .value("Coherence", index < coherenceData.count ? coherenceData[index] : Double.nan),
                        series: .value("Weight", "B")
                    )
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(frequencyData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Frequency", frequencyData[index]),
                        y: .value("Magnitude", index < magnitudeData.count ? magnitudeData[index] : Double.nan),
                        series: .value("Weight", "A")
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }
            }
            // .chartForegroundStyleScale(["1":.blue, "2":.red])
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
            .chartYAxis {
                AxisMarks(position: .leading, values: dbYAxisValues) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)")
                        }
                    }
                }
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Frequency (Hz)")
            }
            .chartXScale(domain: 20 ... 20000, type: .log)
            .chartYAxisLabel(position: .trailing, alignment: .center) {
                Text("Magnitude (dB)")
            }
            .chartYScale(domain: -35 ... 35, type: .linear)
            .clipped()
            .frame(height: 200)
        }
    }
}
