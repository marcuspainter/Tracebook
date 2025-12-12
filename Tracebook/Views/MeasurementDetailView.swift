//
//  MeasurementView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI

@MainActor
struct MeasurementDetailView: View {
    //@Environment(\.modelContext) private var modelContext
    @Bindable var measurement: MeasurementItem

    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var threshold: Double = 0.0

    let dataProcessor: MeasurementProcessor

    init(measurement: MeasurementItem) {
        let frequency = measurement.content?.tfFrequency ?? []
        let magnitude = measurement.content?.tfMagnitude ?? []
        let phase = measurement.content?.tfPhase ?? []
        let coherence = measurement.content?.tfCoherence ?? []
        self.dataProcessor = MeasurementProcessor(
            frequency: frequency,
            magnitude: magnitude,
            phase: phase,
            coherence: coherence
        )
        self.measurement = measurement
    }

    var body: some View {
        Group {
            ScrollView {
                VStack {

                    MagnitudeChart(
                        frequency: dataProcessor.frequency,
                        magnitude: dataProcessor.magnitude,
                        coherence: dataProcessor.coherence
                    )

                    PhaseChart(
                        frequency: dataProcessor.frequency,
                        phase: dataProcessor.phase,
                        originalPhase: dataProcessor.originalPhase
                    )

                    HStack {
                        if let url = URL(string: measurement.slug) {
                            Link("View on Tracebook", destination: url)
                                .font(.footnote)
                        }
                    }

                    HStack {
                        Toggle("Invert", isOn: $isPolarityInverted)

                            .frame(width: 130, alignment: .leading)
                        Button("Reset") {
                            resetChart()
                        }
                        .padding(5)
                        .overlay(  // Apply a rounded border
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.tint, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .onChange(of: isPolarityInverted) { _, _ in
                        // Process phase
                        updateChart()
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
                        in: -20...20,
                        step: 0.1,

                    ) {

                    } minimumValueLabel: {
                        Text("-20").font(.footnote)
                    } maximumValueLabel: {
                        Text("20").font(.footnote)
                    }
                    .onChange(of: delay) { _, _ in
                        updateChart()
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
                        in: 0...100,
                        step: 1
                    ) {
                    } minimumValueLabel: {
                        Text("0").font(.footnote)
                    } maximumValueLabel: {
                        Text("100").font(.footnote)
                    }
                    .onChange(of: threshold) { _, _ in
                        // Update all
                        updateChart()
                    }

                    let content = measurement.content

                    TextLine(text: "Calibrator Reference:", value: content?.calibrator)
                    TextLine(text: "Microphone:", value: content?.microphoneText)
                    TextLine(text: "Distance:", value: valueUnit(content?.distance, content?.distanceUnits))
                    TextLine(text: "Delay locator:", value: valueUnit(content?.delayLocator, "ms"))
                    TextLine(text: "System latency:", value: valueUnit(content?.systemLatency, "ms"))
                    TextLine(text: "Temperature:", value: valueUnit(content?.temperature, content?.tempUnits))
                    TextLine(text: "Microphone interface:", value: content?.interfaceText)
                    TextLine(text: "Microphone interface settings:", value: "")
                    TextLine(text: "Microphone correction curve:", value: content?.micCorrectionCurve)
                    TextLine(text: "Windscreen:", value: content?.windscreen)
                    TextLine(text: "Analyzer:", value: content?.analyzerText)
                    TextLine(text: "Coherence:", value: content?.coherenceScale)

                    Divider()

                    TextLine(text: "Preset:", value: content?.dspPreset)
                    TextLine(text: "Processing preset:", value: content?.category)
                    TextLine(text: "Preset version:", value: content?.presetVersion)
                    TextLine(text: "Firmware version:", value: content?.firmwareVersion)
                    TextLine(text: "User Definable Settings:", value: content?.notes)

                    Divider()

                    TextLine(text: "Comments:", value: measurement.commentCreator)

                    VStack {
                        if let photoURL = URL(string: "https:\(content?.photoSetup ?? "")") {
                            Text("Setup").multilineTextAlignment(.leading)
                            Divider()
                            AsyncImage(url: photoURL, content: AsyncImageContent.content)
                        }
                    }

                }
                //.background(.red)
                .padding(20)

                .navigationTitle(measurement.title)
                .navigationBarTitleDisplayMode(.inline)
            }

        }
    }

    func updateChart() {
        dataProcessor.processAll(delay: delay, threshold: threshold / 100.0, isPolarityInverted: isPolarityInverted)
    }

    func resetChart() {
        delay = 0.0
        threshold = 0.0
        isPolarityInverted = false
        dataProcessor.reset()
    }
}

#Preview {
    @Previewable var measurement = MeasurementItem(id: UUID().uuidString)
    MeasurementDetailView(measurement: measurement)
}

struct TextLine: View {
    var text: String
    var value: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(text).font(.footnote)
            Text(value ?? "")
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

func valueUnit(_ value: Double?, _ unitString: String?) -> String {
    if let value {
        return value.formatted() + " " + (unitString ?? "")
    }
    return ""
}
