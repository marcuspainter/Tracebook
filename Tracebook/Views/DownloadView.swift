//
//  DownloadView.swift
//  Tracebook
//
//  Created by Marcus Painter on 17/02/2024.
//

import SwiftUI

struct DownloadView: View {
    @State var measurement: MeasurementModel

    var body: some View {
        Text(measurement.title)
            .navigationTitle(measurement.title)
    }
}

#Preview {
    let measurement = MeasurementModel()
    measurement.title = "RCF"
    return DownloadView(measurement: measurement)
}
