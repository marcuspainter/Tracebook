//
//  TraceSymbol.swift
//  Tracebook
//
//  Created by Marcus Painter on 22/04/2024.
//

import Foundation
import SwiftUI

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
