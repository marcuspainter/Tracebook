//
//  MeasurmentContentMapper.swift
//  TracebookDB
//
//  Created by Marcus Painter on 30/07/2025.
//

class MeasurementContentMapper {
    
    static func toModel(body: MeasurementContentBody) -> MeasurementContent? {
        
        let model = MeasurementContent(
            id: body.id,
            firmwareVersion: body.firmwareVersion ?? "",
            loudspeakerBrand: body.loudspeakerBrand ?? "",
            category: body.category ?? "",
            delayLocator: body.delayLocator,
            distance: body.distance,
            dspPreset: body.dspPreset ?? "",
            photoSetup: body.photoSetup ?? "",
            fileAdditional: body.fileAdditional ?? [],
            fileTFCSV: body.fileTFCSV ?? "",
            notes: body.notes ?? "",
            createdDate: DataMapperHelper.parseISODate(body.createdDate),
            createdBy: body.createdBy ?? "",
            modifiedDate: DataMapperHelper.parseISODate(body.modifiedDate),
            distanceUnits: body.distanceUnits ?? "",
            crestFactorM: body.crestFactorM,
            crestFactorPink: body.crestFactorPink,
            loudspeakerModel: body.loudspeakerModel ?? "",
            calibrator: body.calibrator ?? "",
            measurementType: body.measurementType ?? "",
            presetVersion: body.presetVersion ?? "",
            temperature: body.temperature,
            tempUnits: body.tempUnits ?? "",
            responseLoudspeakerBrand: body.responseLoudspeakerBrand ?? "",
            coherenceScale: body.coherenceScale ?? "",
            analyzer: body.analyzer ?? "",
            fileTFNative: body.fileTFNative ?? "",
            splGroundPlane: body.splGroundPlane ?? false,
            responseLoudspeakerModel: body.responseLoudspeakerModel ?? "",
            systemLatency: body.systemLatency,
            microphone: body.microphone ?? "",
            measurement: body.measurement ?? "",
            interface: body.interface ?? "",
            interfaceBrandModel: body.interfaceBrandModel ?? "",
            micCorrectionCurve: body.micCorrectionCurve ?? "",
            
            tfFrequency: DataMapperHelper.parseDoubleArray(body.tfJSONFrequency ?? ""),
            tfMagnitude: DataMapperHelper.parseDoubleArray(body.tfJSONMagnitude ?? ""),
            tfPhase: DataMapperHelper.parseDoubleArray(body.tfJSONPhase ?? ""),
            tfCoherence: DataMapperHelper.parseDoubleArray(body.tfJSONCoherence ?? ""),
            
            medal: body.medal ?? "",
            fileIRWAV: body.fileIRWAV ?? "",
            windscreen: body.windscreen ?? "",
            presetNA: body.presetNA ?? false,
            presetVersionNA: body.presetVersionNA ?? false,
            firmwareVersionNA: body.firmwareVersionNA ?? false,
            inputMeter: body.inputMeter,
            
            item: nil
        )
        return model
    }

}
