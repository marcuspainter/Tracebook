//
//  TraceDetailView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Charts
import SwiftUI

struct MeasurementDetailView: View {
    @ObservedObject var measurement: MeasurementModel

    @State var magitudeData: [(Double, Double)] = []
    @State var phaseData: [(Double, Double)] = []
    @State var coherenceData: [(Double, Double)] = []
    @State var originalPhaseData: [(Double, Double)] = []

    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var coherence: Double = 0.0

    var body: some View {
        GeometryReader { _ in
            ScrollView {
                VStack {
                    Group {
                        Text("Magnitude")
                        Chart {
                            ForEach(coherenceData, id: \.0) { data in
                                LineMark(
                                    x: .value("x", data.0),
                                    y: .value("y", data.1),
                                    series: .value("Weight", "B")
                                )
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            }

                            ForEach(magitudeData, id: \.0) { data in
                                LineMark(
                                    x: .value("x", data.0),
                                    y: .value("y", data.1),
                                    series: .value("Weight", "A")
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            }
                        }
                        // .chartForegroundStyleScale(["1":.blue, "2":.red])
                        .chartXAxis {
                            AxisMarks(values: [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]) { value in

                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                                //    .foregroundStyle(Color.cyan)
                                // AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
                                //    .foregroundStyle(Color.red)

                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        let textValue = intValue < 999 ? "\(intValue)" : "\(intValue / 1000)k"
                                        Text(textValue)
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: [-60, -50, -40, -30, -20, -10, 0, 10, 20, 30]) { value in
                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        Text("\(intValue)")
                                    }
                                }
                            }
                            /*
                             AxisMarks(position: .trailing, values: [0, 30]) { value in
                                 AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                                 AxisValueLabel {
                                     var textValue = switch value.index {
                                         case 0: "0%"
                                         //case 1: "100%"
                                         default: ""
                                     }
                                     Text(textValue)
                                 }
                             }
                              */
                        }
                        .chartXAxisLabel(position: .bottom, alignment: .center) {
                            Text("Frequency (Hz)")
                        }
                        .chartXScale(domain: 20 ... 20000, type: .log)
                        .chartYAxisLabel(position: .trailing, alignment: .center) {
                            Text("Power (dB)")
                        }
                        .chartYScale(domain: -60 ... 35, type: .linear)
                        .clipped()
                        .frame(height: 200)
                    }

                    Group {
                        Text("Phase")
                        Chart {
                            ForEach(originalPhaseData, id: \.0) { data in
                                LineMark(
                                    x: .value("x", data.0),
                                    y: .value("y", data.1),
                                    series: .value("Weight", "A")
                                )
                                .foregroundStyle(.gray)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            }

                            ForEach(phaseData, id: \.0) { data in
                                LineMark(
                                    x: .value("x", data.0),
                                    y: .value("y", data.1),
                                    series: .value("Weight", "B")
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]) { value in
                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        let textValue = intValue < 999 ? "\(intValue)" : "\(intValue / 1000)k"
                                        Text(textValue)
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                        .chartXAxisLabel(position: .bottom, alignment: .center) {
                            Text("Frequency (Hz)")
                        }
                        .chartXScale(domain: 20 ... 20000, type: .log)
                        .chartYAxis {
                            AxisMarks(position: .leading, values: [-180, -135, -90, -45, 0, 45, 90, 135, 180])
                        }
                        .chartYAxisLabel(position: .trailing, alignment: .center) {
                            Text("Phase (°)")
                        }
                        .chartYScale(domain: -200 ... 200, type: .linear
                        )
                        .clipped()
                        .frame(height: 200)
                    }
                    .navigationTitle(measurement.loudspeakerModel)

                    HStack {
                        Toggle("Invert", isOn: $isPolarityInverted)
                            .onChange(of: isPolarityInverted) { _ in
                                self.phaseData = measurement.processPhase(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                            }.frame(width: 100, alignment: .leading)
                        Button("Reset") {
                            delay = 0.0
                            coherence = 0.0
                            isPolarityInverted = false
                        }
                        .padding(5)
                        // .foregroundColor(Color(.systemGray))
                        .overlay( // apply a rounded border
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.tint, lineWidth: 1))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    HStack {
                        Text("Delay").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(delay, specifier: "%.1f") ms").monospacedDigit().frame(maxWidth: .infinity, alignment: .center)
                        Color.clear.frame(maxWidth: .infinity)
                    }
                    Slider(
                        value: $delay,
                        in: -20 ... 20,
                        step: 0.1
                    ) {
                        // Text("Delay")
                    } minimumValueLabel: {
                        Text("-20").font(.footnote)
                    } maximumValueLabel: {
                        Text("20").font(.footnote)
                    }
                    .onChange(of: delay) { _ in
                        self.phaseData = measurement.processPhase(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                    }

                    HStack {
                        Text("Coherence").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(coherence, specifier: "%.0f")%").monospacedDigit().frame(maxWidth: .infinity, alignment: .center)
                        Color.clear.frame(maxWidth: .infinity)
                    }

                    Slider(
                        value: $coherence,
                        in: 0 ... 100,
                        step: 1
                    ) {
                    } minimumValueLabel: {
                        Text("0").font(.footnote)
                    } maximumValueLabel: {
                        Text("100").font(.footnote)
                    }
                    .onChange(of: coherence) { _ in
                        self.magitudeData = measurement.processMagnitude(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                        self.phaseData = measurement.processPhase(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                        self.coherenceData = measurement.processCoherence(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                        self.originalPhaseData = measurement.processPhase(delay: 0.0, threshold: coherence, isPolarityInverted: false)
                    }

                    TextLine(text: "Calibrator Reference:", value: measurement.calibrator)
                    TextLine(text: "Microphone:", value: measurement.microphone)
                    TextLine(text: "Distance:", value: measurement.distance.formatted() + " " + measurement.distanceUnits)
                    TextLine(text: "Delay locator:", value: measurement.delayLocator.formatted() + "ms")
                    TextLine(text: "System latency:", value: measurement.systemLatency.formatted() + "ms")
                    TextLine(text: "Temperature:", value: measurement.temperature.formatted() + measurement.tempUnits)
                    TextLine(text: "Microphone interface:", value: measurement.interface)
                    TextLine(text: "Microphone interface settings:", value: "?")
                    TextLine(text: "Microphone correction curve:", value: measurement.micCorrectionCurve)
                    TextLine(text: "Windscreen:", value: "?")
                    TextLine(text: "Analyzer:", value: measurement.analyzer)
                    TextLine(text: "Coherence:", value: measurement.coherenceScale)

                    Divider()

                    TextLine(text: "Preset:", value: measurement.dspPreset)
                    TextLine(text: "Processing preset:", value: "?")
                    TextLine(text: "Preset version:", value: measurement.presetVersion)
                    TextLine(text: "Firmware version:", value: measurement.firmwareVersion)
                    TextLine(text: "User Definable Settings:", value: "?")

                    // TextLine(text: "Comments:", value: "?")
                    // TextLine(text: "Tags:", value: measurement.loudspeakerTags)

                    // AsyncImage(url: URL(string: "https:\(measurement.photoSetup)"), content: asyncImageContent)
                    //    .frame(width: 200, height: 200)
                }
                .onAppear {
                    self.magitudeData = measurement.processMagnitude(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                    self.phaseData = measurement.processPhase(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)
                    self.coherenceData = measurement.processCoherence(delay: delay, threshold: coherence, isPolarityInverted: isPolarityInverted)

                    self.originalPhaseData = measurement.processPhase(delay: 0.0, threshold: coherence, isPolarityInverted: false)
                }

                .padding()
            }
        }
    }
}

#Preview {
    let measurement = MeasurementModel()
    return MeasurementDetailView(measurement: measurement)
}

struct TextLine: View {
    var text: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text).font(.footnote)
            Text(value)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
