//
//  BubbleConstraintType.swift
//  TracebookDB
//
//  Created by Marcus Painter on 08/07/2025.
//

enum BubbleConstraintType: String {
    // Use to test strict equality
    case equals = "equals"
    case notEqual = "not equal"
    // Use to test whether a thing's given field is empty or not
    case isEmpty = "is_empty"
    case isNotEmpty = "is_not_empty"
    // Use to test whether a text field contains a string. Text contains will  not respect partial words that are not
    // of the same stem.
    case textContains = "text contains"
    case notTextContains = "not text contains"
    // Use to compare a thing's field value relative to a given value
    case greaterThan = "greater than"
    case lessThan = "less than"
    // Use to test whether a thing's field is in a list or not for all field types.
    case inField = "in"
    case notInField = "not in"
    // Use to test whether a list field contains an entry or not for list fields only.
    case contains = "contains"
    case notContaiins = "not contains"
    // Use to test whether a list field is empty or not for list fields only.
    case empty = "empty"
    case notEmpty = "not empty"
    // Use to test if the current thing is within a radius from a central address. To use this, the value sent with
    // the constraint must have an address and a range.
    case geographicSearch = "geographic_search"
}
