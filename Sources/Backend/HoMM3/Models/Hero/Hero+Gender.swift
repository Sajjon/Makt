//
//  Hero+Gender.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    enum Gender: UInt8, Equatable {
        case male, female
        
        public init?(raw rawValue: UInt8) throws {
            switch rawValue {
            case Gender.male.rawValue: self = .male
            case Gender.female.rawValue: self = .female
            case Self.useDefault: return nil
            default: throw Error.unrecognizedGender(rawValue)
            }
        }
    }
}

public extension Hero.Gender {
    
    enum Error: Swift.Error {
        case unrecognizedGender(RawValue)
    }
    
    /// No gender override, use the default of the Hero. E.g. `Orrin` is a `male`, and if in e.g. `parsePredefinedHeroes` we received value `0xff`, it means that we do not want to override his gender, so logic elsewhere should keep his gender as `male`.
    static let useDefault: Self.RawValue = 0xff
}
