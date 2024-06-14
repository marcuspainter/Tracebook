//
//  MeasurementEntity+CoreDataProperties.swift
//  Tracebook
//
//  Created by Marcus Painter on 23/04/2024.
//
//

import Foundation
import CoreData


extension MeasurementEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeasurementEntity> {
        return NSFetchRequest<MeasurementEntity>(entityName: "MeasurementEntity")
    }

    @NSManaged public var additionalContent: String?
    @NSManaged public var admin1Approved: String?
    @NSManaged public var admin2Approved: String?
    @NSManaged public var analyzer: String?
    @NSManaged public var approved: String?
    @NSManaged public var calibrator: String?
    @NSManaged public var category: String?
    @NSManaged public var coherenceScale: String?
    @NSManaged public var commentCreator: String?
    @NSManaged public var contentId: String?
    @NSManaged public var createdBy: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var delayLocator: Double
    @NSManaged public var distance: Double
    @NSManaged public var distanceUnits: String?
    @NSManaged public var dspPreset: String?
    @NSManaged public var emailSent: Bool
    @NSManaged public var fileIRWAV: String?
    @NSManaged public var fileTFCSV: String?
    @NSManaged public var fileTFNative: String?
    @NSManaged public var firmwareVersion: String?
    @NSManaged public var id: String?
    @NSManaged public var interface: String?
    @NSManaged public var isPublic: Bool
    @NSManaged public var loudspeakerTags: String?
    @NSManaged public var medal: String?
    @NSManaged public var micCorrectionCurve: String?
    @NSManaged public var microphone: String?
    @NSManaged public var moderator1: String?
    @NSManaged public var moderator2: String?
    @NSManaged public var modifiedDate: String?
    @NSManaged public var notes: String?
    @NSManaged public var photoSetup: String?
    @NSManaged public var presetVersion: String?
    @NSManaged public var productLaunchDateText: String?
    @NSManaged public var publishDate: String?
    @NSManaged public var slug: String?
    @NSManaged public var systemLatency: Double
    @NSManaged public var temperature: Double
    @NSManaged public var tempUnits: String?
    @NSManaged public var tfJSONCoherence: String
    @NSManaged public var tfJSONFrequency: String
    @NSManaged public var tfJSONMagnitude: String
    @NSManaged public var tfJSONPhase: String
    @NSManaged public var thumbnailImage: String?
    @NSManaged public var title: String?
    @NSManaged public var tracebookURL: String?
    @NSManaged public var upvotes: String?
    @NSManaged public var windscreen: String?

}

extension MeasurementEntity : Identifiable {

}
