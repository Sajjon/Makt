//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Malm
@testable import Guld
import XCTest

final class GuldTests: XCTestCase {

    func test__H3sprite_lod__parsing() throws {
        let config = try Config()
        let assetsProvider = AssetsProvider(config: config)
        let spriteLodFile = try assetsProvider.open(archive: .lod(.restorationOfErathiaSpriteArchive))
        let spriteLodName = "H3sprite.lod"
        XCTAssertEqual(spriteLodFile.fileName, spriteLodName)
        
        let parser = LodParser()
        let inspector = AssetParsedInspector(onParseFileEntry: { entry in
            XCTAssertEqual( entry.parentArchiveName, spriteLodName)
        })
        let spriteLod = try parser.parse(archiveFile: spriteLodFile, inspector: inspector)
        XCTAssertEqual(spriteLod.entries.count, 4013)
    }
}
