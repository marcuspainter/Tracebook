//
//  ArrayTransformer.swift
//  TracebookMV
//
//  Created by Marcus Painter on 15/02/2024.
//

// https://www.avanderlee.com/swift/valuetransformer-core-data/

import Foundation

/// Stores arrays of any `Codable` type.
/// Must register before using
@objc
public class DoubleArrayValueTransformer: ValueTransformer {
    public override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? [Double],
              let data = try? JSONEncoder().encode(value) else {
            return nil
        }
        return data as NSData
    }

    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData,
              let array = try? JSONDecoder().decode([Double].self, from: data as Data) else {
            return nil
        }
        return array
    }
}

/// Functions for registering this class as a ValueTransformer
public extension DoubleArrayValueTransformer {
    /// The name as a string to be used in the `attribute.valueTransformerName`.
    static var nameString: String { String(describing: DoubleArrayValueTransformer.self) }

    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static var name: NSValueTransformerName { .init(rawValue: String(describing: DoubleArrayValueTransformer.self)) }

    /// Registers the value transformer with `ValueTransformer`.
    static func register() {
        let transformer = DoubleArrayValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
