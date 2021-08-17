//
//  Map+Loader+Parser.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map.Loader {
    final class Parser {
        private let config: Config
        private let decompressor: Decompressor
        init(config: Config, decompressor: Decompressor = Map.Loader.Parser.GzipDecompressor() ) {
            self.config = config
            self.decompressor = decompressor
        }
    }
}


public extension Map.Loader.Parser {

  
    func parse(readMap: Map.Loader.ReadMap) throws -> Map {
        let stream = DataReader(readMap: readMap)
        let formatRawValue = try stream.readUInt32()
        let h3mParser: H3M
        if decompressor.isHeaderCompressed(format: formatRawValue) {
            h3mParser = try decompressor.parser(readMap: readMap)
        } else {
            let format = try Map.Format(id: formatRawValue)
            switch format {
            case .hornOfTheAbyss: fatalError("Unknown if hota is supported")
            case .wakeOfGods, .armageddonsBlade, .restorationOfErathia,.shadowOfDeath:
                h3mParser = H3M(readMap: readMap)
            }
        }
        return try h3mParser.parse()
    
        
    }
}





