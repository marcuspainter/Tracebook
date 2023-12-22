// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let speaker = try? JSONDecoder().decode(Speaker.self, from: jsonData)

import Foundation

// MARK: - Speaker
struct SpeakerList: Codable {
    let docs: [Doc]
}

// MARK: - Doc
struct Doc: Codable {
    let version: Int
    let found: Bool
    let source: Source
    let type: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case version = "_version"
        case found
        case source = "_source"
        case type = "_type"
        case id = "_id"
    }
}

// MARK: - Source
struct Source: Codable {
    let ampFirmwareText: String?
    let categoryText: String?
    let delayLocatorNumber, distanceNumber: Double?
    let dspPresetText, featuredImageImage: String?
    let fileAdditionalListFile: [String]?
    let fileCSVFile: String?
    let createdDate: Int?
    let createdBy: String?
    let modifiedDate: Int?
    let measurementUnitsText: String?
    let tempUnitsText: String?
    let loudspeakerBrandCustomLoudspeakerBrand: String?
    let coherenceSettingText: String?
    let distanceUnitsSplText: String?
    let fileTfNativeFile, fileIRWavFile: String?
    let splGroundPlaneBoolean: Bool?
    let loudspeakerModelCustomLoudspeakerModel: String?
    let microphoneCustomMicrophone: String?
    let measurementCustomMeasurement: String?
    let analyzerNameCustomAnalyzer: String?
    let presetNaBoolean, presetVersionNaBoolean, presetFirmwareNaBoolean: Bool?
    let inputMeterNumber: Int?
    let loudspeakerSerialNumberText: String?
    let interfaceCustomInterface: String?
    let micCorrectionCurveText: String?
    let smallestRoomDimensionUnitsBoolean: Bool?
    let loudspeakerWidthNumber, loudspeakerHeightNumber: Double?
    let loudspeakerDimensionUnitsBoolean: Bool?
    let smallestRoomDimensionUnits1Text: String?
    let medalText: String?
    let windscreenText: String?
    let userCommentLastEmailDateDate: Int?
    let commentsAdminListCustomCommentAdmin: [String]?
    let tfJSONFrequencyText, tfJSONMagnitudeText, tfJSONPhaseText, tfJSONCoherenceText: String?
    let id: String?
    let version: Int?
    let type: String?
    let nameText, photoImage, headlineText, firstNameText: String?
    let lastNameText: String?
    let measurementsCreatedListCustomMeasurement: [String]?
    let referralCodeText: String?
    let authentication: Authentication?
    let userSignedUp: Bool?
    let locationText: String?
    let followersListUser, followingListUser, commentsListCustomComment: [String]?
    let notesText: String?
    let calibratorText: String?
    let temperatureNumber: Double?
    let loudspeakerModelText, fileIRCSVFile, interfaceUserDefinableText: String?
    let interfaceBrandModelText: String?
    let splDataBoolean: Bool?
    let ampCategoryText: String?
    let ampsListCustomAmp: [String]?
    let loudspeakerManufacturingDateDate: Int?
    let systemLatencyNumber: Double?
    let interfaceMaxOutputV1Number: Int?

    enum CodingKeys: String, CodingKey {
        case ampFirmwareText = "amp_firmware_text"
        case categoryText = "category_text"
        case delayLocatorNumber = "delay_locator_number"
        case distanceNumber = "distance_number"
        case dspPresetText = "dsp_preset_text"
        case featuredImageImage = "featured_image_image"
        case fileAdditionalListFile = "file_additional_list_file"
        case fileCSVFile = "file_csv_file"
        case createdDate = "Created Date"
        case createdBy = "Created By"
        case modifiedDate = "Modified Date"
        case measurementUnitsText = "measurement_units_text"
        case tempUnitsText = "temp_units_text"
        case loudspeakerBrandCustomLoudspeakerBrand = "loudspeaker_brand_custom_loudspeaker_brand"
        case coherenceSettingText = "coherence_setting_text"
        case distanceUnitsSplText = "distance_units_spl_text"
        case fileTfNativeFile = "file_tf_native_file"
        case fileIRWavFile = "file_ir_wav_file"
        case splGroundPlaneBoolean = "spl_ground_plane_boolean"
        case loudspeakerModelCustomLoudspeakerModel = "_loudspeaker_model_custom_loudspeaker_model"
        case microphoneCustomMicrophone = "_microphone_custom_microphone"
        case measurementCustomMeasurement = "measurement_custom_measurement"
        case analyzerNameCustomAnalyzer = "_analyzer_name_custom_analyzer"
        case presetNaBoolean = "preset_na_boolean"
        case presetVersionNaBoolean = "preset_version_na_boolean"
        case presetFirmwareNaBoolean = "preset_firmware_na_boolean"
        case inputMeterNumber = "input_meter_number"
        case loudspeakerSerialNumberText = "loudspeaker_serial_number_text"
        case interfaceCustomInterface = "_interface_custom_interface"
        case micCorrectionCurveText = "mic_correction_curve_text"
        case smallestRoomDimensionUnitsBoolean = "smallest_room_dimension_units_boolean"
        case loudspeakerWidthNumber = "loudspeaker_width_number"
        case loudspeakerHeightNumber = "loudspeaker_height_number"
        case loudspeakerDimensionUnitsBoolean = "loudspeaker_dimension_units_boolean"
        case smallestRoomDimensionUnits1Text = "smallest_room_dimension_units1_text"
        case medalText = "medal_text"
        case windscreenText = "windscreen_text"
        case userCommentLastEmailDateDate = "user_comment_last_email_date_date"
        case commentsAdminListCustomCommentAdmin = "comments_admin_list_custom_comment_admin"
        case tfJSONFrequencyText = "tf_json_frequency_text"
        case tfJSONMagnitudeText = "tf_json_magnitude_text"
        case tfJSONPhaseText = "tf_json_phase_text"
        case tfJSONCoherenceText = "tf_json_coherence_text"
        case id = "_id"
        case version = "_version"
        case type = "_type"
        case nameText = "name_text"
        case photoImage = "photo_image"
        case headlineText = "headline_text"
        case firstNameText = "first_name_text"
        case lastNameText = "last_name_text"
        case measurementsCreatedListCustomMeasurement = "measurements_created_list_custom_measurement"
        case referralCodeText = "referral_code_text"
        case authentication
        case userSignedUp = "user_signed_up"
        case locationText = "location_text"
        case followersListUser = "followers_list_user"
        case followingListUser = "following_list_user"
        case commentsListCustomComment = "comments_list_custom_comment"
        case notesText = "notes_text"
        case calibratorText = "calibrator_text"
        case temperatureNumber = "temperature_number"
        case loudspeakerModelText = "loudspeaker_model_text"
        case fileIRCSVFile = "file_ir_csv_file"
        case interfaceUserDefinableText = "interface_user_definable_text"
        case interfaceBrandModelText = "interface_brand_model_text"
        case splDataBoolean = "spl_data_boolean"
        case ampCategoryText = "amp_category_text"
        case ampsListCustomAmp = "amps_list_custom_amp"
        case loudspeakerManufacturingDateDate = "loudspeaker_manufacturing_date_date"
        case systemLatencyNumber = "system_latency_number"
        case interfaceMaxOutputV1Number = "interface_max_output_v1_number"
    }
}

// MARK: - Authentication
struct Authentication: Codable {
    let email: Empty?
    let linkedin: Empty?
}

struct Empty: Codable {

}
