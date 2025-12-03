//
//  BubbleSortKey.swift
//  TracebookDB
//
//  Created by Marcus Painter on 13/02/2024.
//

import Foundation

struct BubbleSortKey: CustomStringConvertible {
    let sortField: String
    let order: BubbleSortKeyOrder

    var description: String {
        let isDescending = order == .descending
        return "{\"sort_field\":\"\(sortField)\",\"descending\":\"\(isDescending)\"}"
    }

    init(sortField: String, order: BubbleSortKeyOrder = .ascending) {
        self.sortField = sortField
        self.order = order
    }
}
