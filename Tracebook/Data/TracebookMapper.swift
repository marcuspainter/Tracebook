//
//  TracebookMapper.swift
//  Tracebook
//
//  Created by Marcus Painter on 21/04/2024.
//

import Foundation

class TracebookMapper {
    static func measurementBodyContentToEntity(body: MeasurementContentBody, entity: MeasurementEntity) {
        entity.contentId = body.id

        entity.calibrator = body.calibrator
        entity.coherenceScale = body.coherenceScale
        entity.delayLocator = body.delayLocator ?? 0.0
        entity.distance = body.distance ?? 0.0
        entity.distanceUnits = body.distanceUnits
        entity.fileIRWAV = body.fileIRWAV
        entity.fileTFCSV = body.fileTFCSV
        entity.fileTFNative = body.fileTFNative
        entity.medal = body.medal
        entity.micCorrectionCurve = body.micCorrectionCurve
        entity.systemLatency = body.systemLatency ?? 0.0
        entity.temperature = body.temperature ?? 0.0
        entity.tempUnits = body.tempUnits
        entity.tfJSONCoherence = body.tfJSONCoherence ?? ""
        entity.tfJSONFrequency = body.tfJSONFrequency  ?? ""
        entity.tfJSONMagnitude = body.tfJSONMagnitude  ?? ""
        entity.tfJSONPhase = body.tfJSONPhase ?? ""
        entity.windscreen = body.windscreen
    }

    static func measurementBodyToProperties(body: MeasurementBody) -> [String: Any] {
        var properties = [String: Any]()
        properties["id"] = body.id
        properties["additionalContent"] = body.additionalContent
        properties["admin1Approved"] = body.admin1Approved
        properties["admin2Approved"] = body.admin2Approved
        properties["approved"] = body.approved
        properties["commentCreator"] = body.commentCreator
        properties["createdBy"] = body.createdBy
        properties["createdDate"] = body.createdDate
        // properties["emailSent"] = body.id
        // properties["isPublic"] = body.isPublic
        // properties["loudspeakerTags"] = body.loudspeakerTags
        properties["moderator1"] = body.moderator1
        properties["moderator2"] = body.moderator2
        properties["modifiedDate"] = body.modifiedDate
        properties["productLaunchDateText"] = body.productLaunchDateText
        properties["publishDate"] = body.publishDate
        properties["slug"] = body.slug
        properties["thumbnailImage"] = body.thumbnailImage
        properties["title"] = body.title
        // properties["tracebookURL"] = body.tracebookURL
        // properties["upvotes"] = body.upvotes

        return properties
    }

    static func measurementContentBodyToProperties(body: MeasurementContentBody) -> [String: Any] {
        var properties = [String: Any]()

        // properties["id"] = body.id
        properties["analyzer"] = body.analyzer
        properties["calibrator"] = body.calibrator
        properties["coherenceScale"] = body.coherenceScale
        properties["delayLocator"] = body.delayLocator
        properties["distance"] = body.distance
        properties["distanceUnits"] = body.distanceUnits
        properties["fileIRWAV"] = body.fileIRWAV
        properties["fileTFCSV"] = body.fileTFCSV
        properties["fileTFNative"] = body.fileTFNative
        properties["medal"] = body.medal
        properties["micCorrectionCurve"] = body.micCorrectionCurve
        properties["microphone"] = body.microphone
        properties["systemLatency"] = body.systemLatency
        properties["temperature"] = body.temperature
        properties["tempUnits"] = body.tempUnits
        properties["tfJSONCoherence"] = body.tfJSONCoherence
        properties["tfJSONFrequency"] = body.tfJSONFrequency
        properties["tfJSONMagnitude"] = body.tfJSONMagnitude
        properties["tfJSONPhase"] = body.tfJSONPhase
        properties["windscreen"] = body.windscreen
        return properties

        // Not used
         /*
         properties["analyzer"] = body.analyzer
         properties["calibrator"] = body.calibrator
         properties["category"] = body.category
         properties["coherenceScale"] = body.coherenceScale
         //properties["createdBy"] = body.createdBy
         //properties["createdDate"] = body.createdDate
         properties["crestFactorM"] = body.crestFactorM
         properties["crestFactorPink"] = body.crestFactorPink
         properties["delayLocator"] = body.delayLocator
         properties["distance"] = body.distance
         properties["distanceUnits"] = body.distanceUnits
         properties["dspPreset"] = body.dspPreset
         properties["fileAdditional"] = body.fileAdditional
         properties["fileIRWAV"] = body.fileIRWAV
         properties["fileTFCSV"] = body.fileTFCSV
         properties["fileTFNative"] = body.fileTFNative
         properties["firmwareVersion"] = body.firmwareVersion
         properties["firmwareVersionNA"] = body.firmwareVersionNA

         properties["interface"] = body.interface
         properties["inputMeter"] = body.inputMeter
         properties["loudspeakerBrand"] = body.loudspeakerBrand
         properties["loudspeakerModel"] = body.loudspeakerModel
         properties["measurement"] = body.measurement
         properties["measurementType"] = body.measurementType
         properties["medal"] = body.medal
         properties["micCorrectionCurve"] = body.micCorrectionCurve

         properties["microphone"] = body.microphone
         properties["micCorrectionCurve"] = body.micCorrectionCurve
         //properties["modifiedDate"] = body.micCorrectionCurve
         properties["notes"] = body.notes
         properties["photoSetup"] = body.photoSetup
         properties["presetNA"] = body.presetNA
         properties["presetVersion"] = body.presetVersion
         properties["presetVersionNA"] = body.presetVersionNA

         properties["responseLoudspeakerBrand"] = body.responseLoudspeakerBrand
         properties["responseLoudspeakerModel"] = body.responseLoudspeakerModel
         properties["splGroundPlane"] = body.splGroundPlane
         properties["systemLatency"] = body.systemLatency
         properties["temperature"] = body.temperature
         properties["tempUnits"] = body.tempUnits

         properties["tfJSONCoherence"] = body.tfJSONCoherence
         properties["tfJSONFrequency"] = body.tfJSONFrequency
         properties["tfJSONMagnitude"] = body.tfJSONMagnitude
         properties["tfJSONPhase"] = body.tfJSONPhase
         properties["windscreen"] = body.windscreen

         return properties
          */
    }
    
    static func csvToDoubleArray(_ csvString: String?) -> [Double] {
        let array = csvString?.components(separatedBy: ",") ?? []
        let text = array.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let result = text.map { Double($0) ?? 0.0 }
        return result
    }
    
}
