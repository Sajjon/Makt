//
//  Map+Loader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation
import Malm


extension Map {
    
    /// Reader, parser and caching of maps from disc.
    ///
    /// `internal` access modifier so that it can be tested.
    internal static let loader = Loader.shared
}

// MARK: Load
public extension Map {
    
    static func load(
        _ mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        try loader.load(id: mapID, inspector: inspector)
    }
}



public extension Map {
    final class Loader {
        
        private let config: Config
        private let reader: Reader
        
        private let parser: Parser
        
        /// A simple cache for maps so that they can be loaded faster
        /// next time.
        /// 
        /// `internal` access modifier so that it can be tested.
        internal let cache: Cache
        
        init(
            config: Config,
            reader: Reader,
            parser: Parser,
            cache: Cache
        ) {
            self.config = config
            self.reader = reader
            self.parser = parser
            self.cache = cache
        }
    }
}

// MARK: Init
public extension Map.Loader {
    
    static let shared = Map.Loader()
    
    convenience init(
        config: Config = try! .init()
    ) {
        self.init(
            config: config,
            reader: .init(config: config),
            parser: .init(config: config),
            cache: .init(config: config)
        )
    }
}

// MARK: Public
public extension Map.Loader {
    
    func load(
        id mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        if let cachedMap = cache.load(id: mapID) {
            return cachedMap
        }
        let readMap = try reader.read(by: mapID)
        let parsedMap = try parser.parse(readMap: readMap, inspector: inspector)
        cache.save(map: parsedMap)
        return parsedMap
    }
}

// MARK: Error
public extension Map.Loader {
    enum Error: Swift.Error {
        case mapFileNotFound(at: String)
    }
    
}
