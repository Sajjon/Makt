//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct RGB: Hashable, CustomDebugStringConvertible {
    public typealias Value = UInt8
    public let red: Value
    public let green: Value
    public let blue: Value
}

public extension RGB {
    var debugDescription: String {
        [red, green, blue].map { String(describing: $0) }.joined(separator: ", ")
    }
}

public struct RGBA: Hashable, CustomDebugStringConvertible {
    public let rgb: RGB
    public let alpha: RGB.Value
    
}

public extension RGBA {
    var red: RGB.Value { rgb.red }
    var green: RGB.Value { rgb.green }
    var blue: RGB.Value { rgb.blue }
    
    var debugDescription: String {
        let values = [red, green, blue, alpha].map { String(describing: $0) }.joined(separator: ", ")
        return "(\(values))"
    }
}
