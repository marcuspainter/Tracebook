//
//  Measurement+CoreDataProperties.swift
//  Tracebook
//
//  Created by Marcus Painter on 26/03/2024.
//
//

import Foundation
import CoreData

extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement")
    }

    @NSManaged public var additionalContent: String?
    @NSManaged public var analyzer: String?
    @NSManaged public var analyzerName: String?
    @NSManaged public var approved: String?
    @NSManaged public var calibrator: String?
    @NSManaged public var category: String?
    @NSManaged public var coherenceScale: String?
    @NSManaged public var commentCreator: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var delayLocator: Double
    @NSManaged public var distance: Double
    @NSManaged public var distanceUnits: String?
    @NSManaged public var dspPreset: String?
    @NSManaged public var fileIRWAV: String?
    @NSManaged public var fileTFCSV: String?
    @NSManaged public var firmwareVersion: String?
    @NSManaged public var id: String?
    @NSManaged public var interface: String?
    @NSManaged public var interfaceName: String?
    @NSManaged public var loudspeakerTags: [String]?
    @NSManaged public var medal: String?
    @NSManaged public var micCorrectionCurve: String?
    @NSManaged public var microphone: String?
    @NSManaged public var microphoneName: String?
    @NSManaged public var notes: String?
    @NSManaged public var photoSetup: String?
    @NSManaged public var presetVersion: String?
    @NSManaged public var setupPhoto: String?
    @NSManaged public var systemLatency: Double
    @NSManaged public var temperature: Double
    @NSManaged public var tempUnits: String?
    @NSManaged public var tfJSONCoherence: [Double]?
    @NSManaged public var tfJSONFrequency: [Double]?
    @NSManaged public var tfJSONMagnitude: [Double]?
    @NSManaged public var tfJSONPhase: [Double]?
    @NSManaged public var thumbnailImage: String?
    @NSManaged public var title: String?
    @NSManaged public var tracebookURL: String?
    @NSManaged public var windscreen: String?

}

extension Measurement: Identifiable {

}
