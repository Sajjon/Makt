//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation

public enum IDFromRawValueError<Model>: Swift.Error where Model: RawRepresentable {
    case genericUnrecognizedRawValue(Model.RawValue, tryingToInit: Model.Type = Model.self)
    case genericInteger(tooLarge: Int, tryingPassAsRawValueWhenInit: Model.Type = Model.self)
}

public extension RawRepresentable where RawValue: FixedWidthInteger {
    init(id rawValue: RawValue) throws {
        guard let selfValue = Self(rawValue: rawValue) else {
            throw IDFromRawValueError<Self>.genericUnrecognizedRawValue(rawValue)
        }
        self = selfValue
    }
}
public extension RawRepresentable where RawValue: UnsignedInteger & FixedWidthInteger {
    
    init<I>(integer: I) throws where I: FixedWidthInteger {
        do {
            let rawValue = try RawValue(integer: integer)
            try self.init(id: rawValue)
        } catch {
            throw IDFromRawValueError<Self>.genericInteger(tooLarge: Int(integer))
        }
    }
}
