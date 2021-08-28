//
//  Map+Loader+Parser+H3M+ParseAbout.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation



// MARK: Parse Map+Summary
extension  Map.Loader.Parser.H3M {

    
    func parseBasicInfo() throws -> Map.BasicInformation {
        // Check map for validity
        guard reader.sourceSize >= 50 else { throw Error.corruptMapFileTooSmall }
        // Map version
        let format = try Map.Format(id: reader.readUInt32())
        
        if
            !(format == .restorationOfErathia || format == .armageddonsBlade || format == .shadowOfDeath)

        {
            var shouldThrow = true
                    #if WOG
                    if format == .wakeOfGods {
                        shouldThrow = false
                    }
                    #endif // WOG
            if shouldThrow {
                throw Error.unsupportedFormat(format)
            }
        }
        
        /// VCMI variable name `hasPlayablePlayers` but with comment `"unused"`
        try reader.skip(byteCount: 1)
        
        let sizeValue = try reader.readUInt32()
        let height = sizeValue
        let width = sizeValue
        let size = Size(width: .init(width), height: .init(height))
        let hasTwoLevels = try reader.readBool()
        let name = try reader.readString()
        let description = try reader.readString()
        
        let difficulty = try Difficulty(integer: reader.readUInt8()) // VCMI uses read SIGNED Int8 here instead of UInt8. But homm3tools uses UInt8.
        
        let maximumHeroLevel: Int? = try format > .restorationOfErathia ? Int(reader.readUInt8()) : nil
        
        return Map.BasicInformation(
            id: readMap.id,
            fileSize: readMap.data.count,
            fileSizeCompressed: fileSizeCompressed,
            format: format,
            name: name,
            description: description,
            size: size,
            difficulty: difficulty,
            hasTwoLevels: hasTwoLevels,
            maximumHeroLevel: maximumHeroLevel
        )
    }
}
