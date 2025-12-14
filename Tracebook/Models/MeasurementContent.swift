//
//  MeasurementContent.swift
//  Tracebook
//
//  Created by Marcus Painter on 12/07/2025.
//

import Foundation
import SwiftData

@Model
final class MeasurementContent {
    var id: String
    var firmwareVersion: String
    var loudspeakerBrand: String
    var category: String
    var delayLocator: Double?
    var distance: Double?
    var dspPreset: String
    var photoSetup: String
    var fileAdditional: String
    var fileTFCSV: String
    var notes: String
    var createdDate: Date?
    var createdBy: String
    var modifiedDate: Date?
    var distanceUnits: String
    var crestFactorM: Double?
    var crestFactorPink: Double?
    var loudspeakerModel: String
    var calibrator: String
    var measurementType: String
    var presetVersion: String
    var temperature: Double?
    var tempUnits: String
    var responseLoudspeakerBrand: String
    var coherenceScale: String
    var analyzer: String
    var fileTFNative: String
    var splGroundPlane: Bool
    var responseLoudspeakerModel: String
    var systemLatency: Double?
    var microphone: String
    var measurement: String
    var interface: String
    var interfaceBrandModel: String
    var micCorrectionCurve: String
    var tfFrequency: [Double]
    var tfMagnitude: [Double]
    var tfPhase: [Double]
    var tfCoherence: [Double]
    var medal: String
    var fileIRWAV: String
    var windscreen: String
    var presetNA: Bool
    var presetVersionNA: Bool
    var firmwareVersionNA: Bool
    var inputMeter: Double?

    // Lookup
    var microphoneText: String
    var analyzerText: String
    var interfaceText: String

    // Relations
    @Relationship var item: MeasurementItem?

    init(
        id: String,
        firmwareVersion: String = "",
        loudspeakerBrand: String = "",
        category: String = "",
        delayLocator: Double? = nil,
        distance: Double? = nil,
        dspPreset: String = "",
        photoSetup: String = "",
        fileAdditional: [String] = [],
        fileTFCSV: String = "",
        notes: String = "",
        createdDate: Date? = nil,
        createdBy: String = "",
        modifiedDate: Date? = nil,
        distanceUnits: String = "",
        crestFactorM: Double? = nil,
        crestFactorPink: Double? = nil,
        loudspeakerModel: String = "",
        calibrator: String = "",
        measurementType: String = "",
        presetVersion: String = "",
        temperature: Double? = nil,
        tempUnits: String = "",
        responseLoudspeakerBrand: String = "",
        coherenceScale: String = "",
        analyzer: String = "",
        fileTFNative: String = "",
        splGroundPlane: Bool = false,
        responseLoudspeakerModel: String = "",
        systemLatency: Double? = nil,
        microphone: String = "",
        measurement: String = "",
        interface: String = "",
        interfaceBrandModel: String = "",
        micCorrectionCurve: String = "",
        tfFrequency: [Double] = [],
        tfMagnitude: [Double] = [],
        tfPhase: [Double] = [],
        tfCoherence: [Double] = [],
        medal: String = "",
        fileIRWAV: String = "",
        windscreen: String = "",
        presetNA: Bool = false,
        presetVersionNA: Bool = false,
        firmwareVersionNA: Bool = false,
        inputMeter: Double? = nil,

        microphoneText: String = "",
        analyzerText: String = "",
        interfaceText: String = "",

        item: MeasurementItem? = nil
    ) {
        self.id = id
        self.firmwareVersion = firmwareVersion
        self.loudspeakerBrand = loudspeakerBrand
        self.category = category
        self.delayLocator = delayLocator
        self.distance = distance
        self.dspPreset = dspPreset
        self.photoSetup = photoSetup
        self.fileAdditional = fileAdditional.joined(separator: ", ")
        self.fileTFCSV = fileTFCSV
        self.notes = notes
        self.createdDate = createdDate
        self.createdBy = createdBy
        self.modifiedDate = modifiedDate
        self.distanceUnits = distanceUnits
        self.crestFactorM = crestFactorM
        self.crestFactorPink = crestFactorPink
        self.loudspeakerModel = loudspeakerModel
        self.calibrator = calibrator
        self.measurementType = measurementType
        self.presetVersion = presetVersion
        self.temperature = temperature
        self.tempUnits = tempUnits
        self.responseLoudspeakerBrand = responseLoudspeakerBrand
        self.coherenceScale = coherenceScale
        self.analyzer = analyzer
        self.fileTFNative = fileTFNative
        self.splGroundPlane = splGroundPlane
        self.responseLoudspeakerModel = responseLoudspeakerModel
        self.systemLatency = systemLatency
        self.microphone = microphone
        self.measurement = measurement
        self.interface = interface
        self.interfaceBrandModel = interfaceBrandModel
        self.micCorrectionCurve = micCorrectionCurve
        self.tfFrequency = tfFrequency
        self.tfMagnitude = tfMagnitude
        self.tfPhase = tfPhase
        self.tfCoherence = tfCoherence
        self.medal = medal
        self.fileIRWAV = fileIRWAV
        self.windscreen = windscreen
        self.presetNA = presetNA
        self.presetVersionNA = presetVersionNA
        self.firmwareVersionNA = firmwareVersionNA
        self.inputMeter = inputMeter

        self.microphoneText = microphoneText
        self.analyzerText = analyzerText
        self.interfaceText = interfaceText

        self.item = item
    }

}
