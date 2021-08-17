//
//  Map+TeamInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct TeamInfo: Equatable {
        public let teams: [Team]
        public struct Team: Equatable {
            public let id: Int
        }
    }
}

