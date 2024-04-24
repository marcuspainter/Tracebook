//
//  TraceDetailView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Charts
import Observation
import SwiftUI

struct PlotData {
    let frequencyData: [Double]
    let magnitudeData: [Double]
    let phaseData: [Double]
    let coherenceData: [Double]
    let originalPhaseData: [Double]
}

struct MagnitudePlotData {
    let frequencyData: [Double]
    let magnitudeData: [Double]
    let coherenceData: [Double]
}

struct PhasePlotData {
    let frequencyData: [Double]
    let phaseData: [Double]
    let coherenceData: [Double]
    let originalPhaseData: [Double]
}

struct MeasurementEntityDetailView: View {
    @ObservedObject var measurement: MeasurementEntity

    @State var plotData: PlotData = PlotData(frequencyData: [], magnitudeData: [], phaseData: [], coherenceData: [], originalPhaseData: [])

    @State var magnitudePlotData = MagnitudePlotData(frequencyData: [], magnitudeData: [], coherenceData: [])
    @State var phasePlotData = PhasePlotData(frequencyData: [], phaseData: [], coherenceData: [], originalPhaseData: [])

    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var threshold: Double = 0.0

    var body: some View {
        Group {
            ScrollView {
                VStack {
                    MagnitudeChart(frequencyData: magnitudePlotData.frequencyData,
                                   magnitudeData: magnitudePlotData.magnitudeData,
                                   coherenceData: magnitudePlotData.coherenceData,
                                   threshold: threshold)

                    PhaseChart(frequencyData: phasePlotData.frequencyData,
                               phaseData: phasePlotData.phaseData,
                               coherenceData: phasePlotData.coherenceData,
                               threshold: threshold,
                               delay: delay,
                               isPolarityInverted: isPolarityInverted)

                    HStack {
                        if let url = URL(string: measurement.tracebookURL ?? "") {
                            Link("View on Tracebook", destination: url)
                                .font(.footnote)
                        }
                    }

                    HStack {
                        Toggle("Invert", isOn: $isPolarityInverted)

                        Button("Reset") {
                            resetChart()
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

                    TextLine(text: "Comments:", value: measurement.commentCreator)

                        /*
                         TextLine(text: "Tags:", value: measurement.loudspeakerTags?.joined(separator: ", ") ?? "")

                         Divider()

                         VStack {
                              Text("Setup").multilineTextAlignment(.leading)
                              AsyncImage(url: URL(string: "https:\(measurement.photoSetup)"), content: AsyncImageHandler.content)
                                  .frame(maxWidth: 400)
                         }
                         */

                        .navigationTitle(measurement.title ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .onChange(of: measurement.contentId) { _ in
                    // Trigger when content is updated from database
                    updateChart()
                }
                .onAppear {
                    updateChart()
                }
                .padding()
            }
        }
    }

    func resetChart() {
        delay = 0.0
        threshold = 0.0
        isPolarityInverted = false
    }

    func updateMagnitudeChart() {
        magnitudePlotData = MagnitudePlotData(frequencyData: measurement.tfJSONFrequency,
                                              magnitudeData: measurement.tfJSONMagnitude,
                                              coherenceData: measurement.tfJSONCoherence)
    }

    func updatePhaseChart() {
        phasePlotData = PhasePlotData(frequencyData: measurement.tfJSONFrequency,
                                      phaseData: measurement.tfJSONPhase,
                                      coherenceData: measurement.tfJSONCoherence,
                                      originalPhaseData: measurement.tfJSONPhase)
    }

    func updateChart() {
        plotData = PlotData(frequencyData: measurement.tfJSONFrequency,
                            magnitudeData: measurement.tfJSONMagnitude,
                            phaseData: measurement.tfJSONPhase,
                            coherenceData: measurement.tfJSONCoherence,
                            originalPhaseData: measurement.tfJSONPhase)

        updateMagnitudeChart()
        updatePhaseChart()
    }
}

/*
 #Preview {
     let measurement = MeasurementEntity()
     return NavigationStack {
         MeasurementEntityDetailView(measurement: measurement)
             .navigationTitle("RCF 710A")
     }
 }
 */
