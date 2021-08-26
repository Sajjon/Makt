//
//  Hero+Disposed.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    struct Disposed: Equatable {
        let heroClass: Class
        let portraitID: ID?
        let name: String
        let availableForPlayers: [PlayerColor]
    }
}
