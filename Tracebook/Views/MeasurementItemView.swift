//
//  TraceView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Foundation
import SwiftUI

struct MeasurementItemView: View {
    var measurement: MeasurementItem

    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: "https:\(measurement.thumbnailImage)"), content: AsyncImageContent.content)
                    .padding(.top, 0)
                    .frame(width: 75, height: 75, alignment: .center)
                Spacer()
            }
            VStack {
                Group {
                    Text(measurement.title)
                    HStack {
                        Text("PRESET:").font(.caption)
                        Text(measurement.content?.dspPreset ?? "").font(.caption)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    TraceBadge(text: "TF", color: .red, isEnabled: measurement.content?.fileTFCSV != "")
                    TraceBadge(text: "IR", color: .yellow, isEnabled: measurement.content?.fileIRWAV != "")
                    TraceBadge(text: "WAV", color: .green, isEnabled: measurement.content?.fileIRWAV != "")
                    TraceBadge(text: "SPL", color: .blue, isEnabled: false)
                    TraceSymbol(symbol: "trophy.fill", colors: [Color(.systemGray), .gray, .yellow],
                                index: measurement.content?.medal == "Gold" ? 2 : measurement.content?.medal == "Silver" ? 1 : 0)
                    TraceSymbol(symbol: "checkmark.circle.fill", colors: [.blue, Color(.systemGray3)],
                                index: measurement.approved ? 0 : 1)
                }.font(.caption)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    Text(measurement.commentCreator)
                        .font(.caption)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .lineLimit(2)

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    @Previewable var measurement = MeasurementItem(id: UUID().uuidString)
    MeasurementItemView(measurement: measurement)
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
