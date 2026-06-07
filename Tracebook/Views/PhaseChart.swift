//
//  PhaseChart.swift
//  Tracebook
//
//  Created by Marcus Painter on 24/07/2025.
//

import SwiftUI
import Charts

struct PhaseChart: View {
    let frequency: [Double]
    let phase: [Double]
    let originalPhase: [Double]

    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let phaseYAxisValues = [-180, -135, -90, -45, 0, 45, 90, 135, 180]
    private var phasePoints: [(frequency: Double, phase: Double)] {
        zip(frequency, phase).map { ($0, $1) }
    }
    private var originalPhasePoints: [(frequency: Double, phase: Double)] {
        zip(frequency, originalPhase).map { ($0, $1) }
    }

    var body: some View {
        Group {
            Text("Phase")
            Chart {
                ForEach(originalPhasePoints.indices, id: \.self) { index in
                    let point = originalPhasePoints[index]
                    LineMark(
                        x: .value("x", point.frequency),
                        y: .value("y", point.phase),
                        series: .value("Weight1", "A")
                    )
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(phasePoints.indices, id: \.self) { index in
                    let point = phasePoints[index]
                    LineMark(
                        x: .value("x", point.frequency),
                        y: .value("y", point.phase),
                        series: .value("Weight2", "B")
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

#Preview {
    PhaseChart(frequency: [20, 20000], phase: [-180, 180], originalPhase: [0,0])
}
