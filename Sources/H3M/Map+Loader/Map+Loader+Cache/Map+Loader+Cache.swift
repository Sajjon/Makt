//
//  Map+Loader+Cache.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation
import Malm

public extension Map.Loader {
    final class Cache {
        private let config: Config

        /// Cache maps for faster access next time
        ///
        /// `internal` access modifier so that it can be tested.
        ///
        internal private(set) var cache: [Map.ID: Map] = [:]

        init(config: Config) {
            self.config = config
        }
    }
}

public extension Map.Loader.Cache {
    
    func load(id: Map.ID) -> Map? {
        cache[id]
    }
    
    func save(map: Map, overwrite: Bool = true) {
        if cache.contains(where: { $0.key == map.id }) && !overwrite {
            return
        }
        cache[map.id] = map
    }
}

extension Map.Loader.Cache {
    /// Used for testing
    internal func __deleteMap(by id: Map.ID) {
        cache.removeValue(forKey: id)
    }
}
