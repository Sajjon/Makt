//
//  Map+Loader+Parser.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation
import Malm
import Common
import Decompressor

public extension Map.Loader {
    final class Parser {
        
        private let config: Config
        private let decompressor: Decompressor
        
        init(
            config: Config,
            decompressor: Decompressor = GzipDecompressor()
        ) {
            self.config = config
            self.decompressor = decompressor
        }
    }
}


public extension Map.Loader.Parser {

    func parseBasicInformation(
        readMap: Map.Loader.ReadMap,
        inspector: Map.Loader.Parser.Inspector.BasicInfoInspector? = nil
    ) throws -> Map.BasicInformation {
        let h3mParser = try parserFor(readMap: readMap)
        return try h3mParser.parseBasicInformation(inspector: inspector)
    }
  
    func parse(
        readMap: Map.Loader.ReadMap,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        let h3mParser = try parserFor(readMap: readMap)
        return try h3mParser.parse(inspector: inspector)
    }
}

private extension Map.Loader.Parser {
    func parserFor(
        readMap: Map.Loader.ReadMap
    ) throws -> Map.Loader.Parser.H3M {
        let reader = DataReader(readMap: readMap)
        let formatRawValue = try reader.readUInt32()
        let h3mParser: H3M
        
        if decompressor.isCompressed(data: readMap.data) {
            let decompressedData: Data = try decompressor.decompress(data: readMap.data)
            
            let readMapDecompressed = Map.Loader.ReadMap(
                data: decompressedData,
                filePath: readMap.filePath,
                id: readMap.id
            )
            
            h3mParser = H3M(
                readMap: readMapDecompressed,
                fileSizeCompressed: readMap.data.count
            )

        } else {
            let format = try Map.Format(id: formatRawValue)
            switch format {
            #if HOTA
            case .hornOfTheAbyss: fatalError("Unknown if hota is supported")
            #endif // HOTA
            
            #if WOG
            case .wakeOfGods: fallthrough
            #endif // WOG
            case .armageddonsBlade, .restorationOfErathia,.shadowOfDeath:
                h3mParser = H3M(readMap: readMap)
            }
        }
        
        return h3mParser
    }
}




