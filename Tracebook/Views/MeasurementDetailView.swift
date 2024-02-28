//
//  TraceDetailView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Charts
import SwiftUI

/*
struct ChartData {
    var magitudeData: [(Double, Double)] = []
    var phaseData: [(Double, Double)] = []
    var coherenceData: [(Double, Double)] = []
    var originalPhaseData: [(Double, Double)] = []
}
 */

struct MeasurementDetailView: View {
    @ObservedObject var measurement: MeasurementModel
    
    @StateObject var user = UserViewModel()
    @State var magitudeData: [(Double, Double)] = []
    @State var phaseData: [(Double, Double)] = []
    @State var coherenceData: [(Double, Double)] = []
    @State var originalPhaseData: [(Double, Double)] = []

    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var threshold: Double = 0.0

    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]
    private let phaseYAxisValues = [-180, -135, -90, -45, 0, 45, 90, 135, 180]

    var body: some View {
        Group {
            ScrollView {
                VStack {
                    
                    MagnitudeChart(magitudeData: magitudeData, coherenceData: coherenceData)

                    PhaseChart(phaseData: phaseData, originalPhaseData: originalPhaseData)

                    HStack {
                        if let url = URL(string: measurement.tracebookURL) {
                            Link("View on Tracebook", destination: url)
                                .font(.footnote)
                        }
                    }
/*
                    NavigationLink {
                        DownloadView(measurement: measurement)
                    } label: {
                        Text("Download")
                    }
*/
                    HStack {
                        Toggle("Invert", isOn: $isPolarityInverted)
                            .onChange(of: isPolarityInverted) { _ in
                                self.phaseData = measurement.processPhase(
                                    delay: delay, threshold: threshold, isPolarityInverted: isPolarityInverted)
                            }.frame(width: 130, alignment: .leading)
                        Button("Reset") {

                        }
                        .padding(5)
                        .overlay( // apply a rounded border
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.tint, lineWidth: 1))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    HStack {
                        Text("Delay").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(delay, specifier: "%.1f") ms")
                            .monospacedDigit()
                            .frame(maxWidth: .infinity, alignment: .center)
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
                        self.phaseData = measurement.processPhase(
                            delay: delay, threshold: threshold, isPolarityInverted: isPolarityInverted)
                    }

                    HStack {
                        Text("Coherence").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(threshold, specifier: "%.0f")%")
                            .monospacedDigit()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Color.clear.frame(maxWidth: .infinity)
                    }

                    Slider(
                        value: $threshold,
                        in: 0 ... 100,
                        step: 1
                    ) {
                    } minimumValueLabel: {
                        Text("0").font(.footnote)
                    } maximumValueLabel: {
                        Text("100").font(.footnote)
                    }
                    .onChange(of: threshold) { _ in
                        updateChart()
                    }

                    TextLine(text: "Calibrator Reference:", value: measurement.calibrator)
                    TextLine(text: "Microphone:", value: measurement.microphone)
                    TextLine(text: "Distance:", value: valueUnit(measurement.distance, measurement.distanceUnits))
                    TextLine(text: "Delay locator:", value: valueUnit(measurement.delayLocator, "ms"))
                    TextLine(text: "System latency:", value: valueUnit(measurement.systemLatency, "ms"))
                    TextLine(text: "Temperature:", value: valueUnit(measurement.temperature, measurement.tempUnits))
                    TextLine(text: "Microphone interface:", value: measurement.interface)
                    TextLine(text: "Microphone interface settings:", value: "")
                    TextLine(text: "Microphone correction curve:", value: measurement.micCorrectionCurve)
                    TextLine(text: "Windscreen:", value: measurement.windscreen)
                    TextLine(text: "Analyzer:", value: measurement.analyzer)
                    TextLine(text: "Coherence:", value: measurement.coherenceScale)

                    Divider()

                    TextLine(text: "Preset:", value: measurement.dspPreset)
                    TextLine(text: "Processing preset:", value: measurement.category)
                    TextLine(text: "Preset version:", value: measurement.presetVersion)
                    TextLine(text: "Firmware version:", value: measurement.firmwareVersion)
                    TextLine(text: "User Definable Settings:", value: measurement.notes)

                    Divider()

                    TextLine(text: "Comments:", value: measurement.commentCreator ?? "")
                    TextLine(text: "Tags:", value: measurement.loudspeakerTags?.joined(separator: ", ") ?? "")

                    Divider()

                    VStack {
                        Text("Setup").multilineTextAlignment(.leading)
                        AsyncImage(url: URL(string: "https:\(measurement.photoSetup)"), content: asyncImageContent)
                            .frame(maxWidth: 400)
                    }
                    .navigationTitle(measurement.title)
                    .navigationBarTitleDisplayMode(.inline)
                }.onChange(of: measurement.distance) { _ in
                    updateChart()
                }

                .onAppear {
                    print("OnAppear")
                    updateChart()

                }
                .padding()
            }
        }
        /*
         .onAppear {
             Task {
                 await user.getUser(id: measurement.createdBy)
             }
         }
          */
    }
    
    func resetChart() {
        delay = 0.0
        threshold = 0.0
        isPolarityInverted = false
    }

    func updateChart() {
        self.magitudeData = measurement.processMagnitude(
            delay: delay, threshold: threshold, isPolarityInverted: isPolarityInverted)
        self.phaseData = measurement.processPhase(
            delay: delay, threshold: threshold, isPolarityInverted: isPolarityInverted)
        self.coherenceData = measurement.processCoherence(
            delay: delay, threshold: threshold, isPolarityInverted: isPolarityInverted)

        // Gray reference trace
        self.originalPhaseData = measurement.processPhase(
            delay: 0.0, threshold: threshold, isPolarityInverted: false)
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

func valueUnit(_ value: Double?, _ unitString: String) -> String {
    if let value {
        return value.formatted() + " " + unitString
    }
    return ""
}

struct MagnitudeChart: View {
    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]

    let magitudeData: [(Double, Double)]
    let coherenceData: [(Double, Double)]

    var body: some View {
        Group {
            Text("Magnitude")
            Chart {
                ForEach(coherenceData, id: \.0) { data in
                    LineMark(
                        x: .value("Frequency", data.0),
                        y: .value("Coherence", data.1),
                        series: .value("Weight", "B")
                    )
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(magitudeData, id: \.0) { data in
                    LineMark(
                        x: .value("Frequency", data.0),
                        y: .value("Magnitude", data.1),
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

struct PhaseChart: View {
    private let frequencyXAxisValues = [15, 31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let dbYAxisValues = [-30, -20, -10, 0, 10, 20, 30]
    private let phaseYAxisValues = [-180, -135, -90, -45, 0, 45, 90, 135, 180]

    let phaseData: [(Double, Double)]
    let originalPhaseData: [(Double, Double)]

    var body: some View {
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
