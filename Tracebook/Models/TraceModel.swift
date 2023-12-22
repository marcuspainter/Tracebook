//
//  Trace.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Foundation

class TraceModel: ObservableObject, Identifiable, Hashable {

    var delayLocator: Double = 0.0
    var distance: Double = 0.0
    var dspPreset: String = ""
    var calibrator: String = ""
    var appFirmware: String = ""
    var category: String = ""
    var coherenceSetting: String = ""

    var id: UUID = UUID()
    var name: String = ""
    var image: String = ""
    var hasTF: Bool = false
    var hasIR: Bool = false
    var hasWav: Bool = false
    var hasSPL: Bool = false
    var hasCup: Bool = false

    var isApproved: Bool = false

    var frequency: [Double] = []
    var magnitude: [Double] = []
    var phase: [Double] = []
    var coherence: [Double] = []

    var preset: String = ""
    var comments: String = ""

    init(name: String, image: String = "") {
        self.name = name
        self.image = image
    }

    static func == (lhs: TraceModel, rhs: TraceModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

}
