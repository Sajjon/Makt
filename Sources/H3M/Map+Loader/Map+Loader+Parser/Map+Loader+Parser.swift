//
//  Map+Loader+Parser.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation
import Malm
import Util
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

  
    func parse(
        readMap: Map.Loader.ReadMap,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
    
        let reader = DataReader(readMap: readMap)
        let formatRawValue = try reader.readUInt32()
        let h3mParser: H3M
        
        if decompressor.isNumberFlaggingCompression(number: formatRawValue) {
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
        return try h3mParser.parse(inspector: inspector)
        
    }
}





