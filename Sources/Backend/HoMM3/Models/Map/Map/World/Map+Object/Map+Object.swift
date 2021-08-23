//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Objects: Hashable {
        public let objects: [Object]
    }
  
    struct Object: Hashable {
        public let position: Position
        public let kind: Kind
    }
}

public extension Map.Object {
    enum Kind: Hashable {
        case event(Map.Event)
        case town(Map.Town)
    }
}
