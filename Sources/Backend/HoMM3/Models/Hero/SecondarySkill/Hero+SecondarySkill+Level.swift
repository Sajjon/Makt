//
//  Hero+SecondarySkill+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero.SecondarySkill {
    enum Level: UInt8, Comparable {
        case basic, advanced, export
    }
}
