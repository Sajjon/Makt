//
//  Creature+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public extension Creature {
    enum Level: Int, Comparable, CaseIterable {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        #if WOG
        case eight
        #endif // WOG
    }
}
