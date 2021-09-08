//
//  Hero+Gender.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    enum Gender: UInt8, Hashable {
        case male
             case female
        
        /// No gender override, use the default of the Hero. E.g. `Orrin` is a `male`, and if in e.g. `parsePredefinedHeroes` we received value `0xff`, it means that we do not want to override his gender, so logic elsewhere should keep his gender as `male`.
                    case defaultGender = 0xff
        
    
    }
}

public extension Hero.Gender {
    
    enum Error: Swift.Error {
        case unrecognizedGender(RawValue)
    }
    

}
