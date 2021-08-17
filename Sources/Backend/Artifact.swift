//
//  Artifact.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Artifact: Equatable, Identifiable {
    public let id: ID
}
public extension Artifact {
    struct ID: Hashable {
        public let id: Int
    }
}
