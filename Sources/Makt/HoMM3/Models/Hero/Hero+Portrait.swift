//
//  Hero+Portrait.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Hero {

    struct Portrait: Equatable, Identifiable {
        public struct ID: Hashable {
            public let id: Int
        }
        public let id: ID
    }
}
