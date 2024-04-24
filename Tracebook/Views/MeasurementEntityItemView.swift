//
//  TraceView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Foundation
import SwiftUI
import Observation

struct MeasurementEntityItemView: View {
    @ObservedObject var measurement: MeasurementEntity

    var body: some View {
        HStack {
        /*    VStack {
                AsyncImage(url: URL(string: "https:\(measurement.thumbnailImage ?? "")"),
                           content: AsyncImageHandler.content)
                    .padding(.top, 0)
                    .frame(width: 75, height: 75, alignment: .center)
                Spacer()
            }
         */
            VStack {
                Group {
                    Text(measurement.title ?? "")
                    HStack {
                        Text("PRESET:").font(.caption)
                        Text(measurement.dspPreset ?? "").font(.caption)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    TraceBadge(text: "TF", color: .red, isEnabled: (measurement.fileTFCSV ?? "") != "")
                    TraceBadge(text: "IR", color: .yellow, isEnabled: (measurement.fileIRWAV ?? "") != "")
                    TraceBadge(text: "WAV", color: .green, isEnabled: (measurement.fileIRWAV ?? "") != "")
                    TraceBadge(text: "SPL", color: .blue, isEnabled: false)
                    
                    TraceSymbol(symbol: "trophy.fill", colors: [Color(.systemGray), .gray, .yellow],
                                index: measurement.medal == "Gold" ? 2 : measurement.medal == "Silver" ? 1 : 0)
                    
                    TraceSymbol(symbol: "checkmark.circle.fill", colors: [.blue, Color(.systemGray3)],
                                index: (measurement.approved ?? "") == "Approved" ? 0 : 1)
                }.font(.caption)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    Text(measurement.commentCreator ?? "")
                        .font(.caption)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .lineLimit(2)

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/*
#Preview {
    let measurement = MeasurementModel()
    return MeasurementItemView(measurement: measurement)
}
 */

