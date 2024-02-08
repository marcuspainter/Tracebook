//
//  TraceView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Foundation
import SwiftUI

struct MeasurementItemView: View {
    @ObservedObject var measurement: MeasurementModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https:\(measurement.thumbnailImage ?? "")"), content: asyncImageContent)
                .padding(.top, 0)
                .frame(width: 75, height: 75, alignment: .top)

            VStack {
                Group {
                    Text(measurement.title)
                    HStack {
                        Text("PRESET:").font(.caption)
                        Text(measurement.dspPreset).font(.caption)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    TraceBadge(text: "TF", color: .red, isEnabled: measurement.fileTFCSV != "")
                    TraceBadge(text: "IR", color: .yellow, isEnabled: measurement.fileIRWAV != "")
                    TraceBadge(text: "WAV", color: .green, isEnabled: measurement.fileIRWAV != "")
                    TraceBadge(text: "SPL", color: .blue, isEnabled: false)
                    TraceSymbol(symbol: "trophy.fill", colors: [Color(.systemGray), .gray, .yellow],
                                index: measurement.medal == "Gold" ? 2 : measurement.medal == "Silver" ? 1 : 0)
                    TraceSymbol(symbol: "checkmark.circle.fill", colors: [.blue, Color(.systemGray3)],
                                index: measurement.approved == "Approved" ? 0 : 1)
                }.font(.caption)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    Text(measurement.commentCreator ?? "")
                        .font(.caption)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        // .border(.green)

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    let measurement = MeasurementModel()
    return MeasurementItemView(measurement: measurement)
}

struct TraceBadge: View {
    let text: String
    let color: Color
    let isEnabled: Bool

    var body: some View {
        if isEnabled {
            Text(text)
                .padding(5)
                .background(color)
                .cornerRadius(5)
        } else {
            Text(text)
                .padding(5)
                .foregroundColor(Color(.systemGray))
                .overlay( // apply a rounded border
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 1))
        }
    }
}

struct TraceSymbol: View {
    let symbol: String
    let colors: [Color]
    let index: Int

    var body: some View {
        Image(systemName: symbol)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(colors[index])
    }
}
