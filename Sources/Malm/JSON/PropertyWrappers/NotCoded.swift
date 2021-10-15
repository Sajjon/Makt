//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-15.
//

import Foundation

/// A property wrapper for properties of a type that should be "skipped" when the type is encoded or decoded.
@propertyWrapper
public struct NotCoded<Value: Hashable>: Hashable {

    
    private var value: Value!
    public init(wrappedValue: Value?) {
        self.value = wrappedValue
    }
    public var wrappedValue: Value? {
        get { value }
        set { self.value = newValue }
    }
}
extension NotCoded: Codable {
    public func encode(to encoder: Encoder) throws {
        // Skip encoding the wrapped value.
    }
    public init(from decoder: Decoder) throws {
        // The wrapped value is simply initialised to nil when decoded.
        self.value = nil
    }
}
