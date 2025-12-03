//
//  MagnitudeView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 24/07/2025.
//

import SwiftUI
import Charts

struct MagnitudeChart: View {
    let frequency: [Double]
    let magnitude: [Double]
    let coherence: [Double]

    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let frequencyXAxisLabels = ["15", "31", "62", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]

    var body: some View {
        Group {
            Text("Magnitude")
            Chart {
                ForEach(frequency.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Frequency", frequency[index]),
                        y: .value("Coherence", coherence[index] * 30),
                        series: .value("Weight", "B")
                    )
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(frequency.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Frequency", frequency[index]),
                        y: .value("Magnitude", magnitude[index]),
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

#Preview {
    MagnitudeChart(frequency: [20,20000], magnitude: [0,10], coherence: [100,100])
}

