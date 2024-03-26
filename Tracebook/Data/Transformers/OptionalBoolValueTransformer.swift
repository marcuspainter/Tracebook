//
//  OptionalBoolValueTransformer.swift
//  Tracebook
//
//  Created by Marcus Painter on 22/02/2024.
//

import Foundation

final class OptionalBoolTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let boolValue = value as? Bool? else {
            return nil
        }
        return boolValue.map(NSNumber.init(value:))
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let numberValue = value as? NSNumber else {
            return nil
        }
        return numberValue.boolValue
    }
    
    static func register() {
        let transformer = OptionalBoolTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "OptionalBoolTransformer"))
    }
}
