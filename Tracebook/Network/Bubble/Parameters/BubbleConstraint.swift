//
//  BubbleConstraint.swift
//  TracebookDB
//
//  Created by Marcus Painter on 11/02/2024.
//

// https://manual.bubble.io/core-resources/api/the-bubble-api/the-data-api/data-api-requests

import Foundation

struct BubbleConstraint: CustomStringConvertible {
    let key: String
    let type: BubbleConstraintType
    let value: String

    var description: String { "{\"key\":\"\(key)\",\"constraint_type\":\"\(type.rawValue)\",\"value\":\"\(value)\"}" }
}
