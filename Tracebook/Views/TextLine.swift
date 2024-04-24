//
//  TextLine.swift
//  Tracebook
//
//  Created by Marcus Painter on 23/04/2024.
//

import Foundation
import SwiftUI

struct TextLine: View {
    var text: String
    var value: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(text).font(.footnote)
            Text(value ?? "")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

func valueUnit(_ value: Double?, _ unitString: String?) -> String {
    if let value, let unitString {
        return value.formatted() + " " + unitString
    }
    return ""
}
