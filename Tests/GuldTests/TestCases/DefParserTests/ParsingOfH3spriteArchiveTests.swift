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
import CryptoKit

/// These expected SHA256 hashes of frames of def files of LOD archive have been
/// generated using `lodextract` fork by me, Alex Cyon, here is the git repo:
/// https://github.com/Sajjon/lodextract
struct ExpectedHashesOfArchive: Codable, Equatable {
    /// Name of archive
    let archive: String
    let hashesOfDefFiles: [ExpectedHashesOfDefFiles]
    
    struct ExpectedHashesOfDefFiles: Codable, Equatable {
        let defFileName: String
        let hashesOfFrames: [ExpectedHashOfFrame]
        
        struct ExpectedHashOfFrame: Codable, Equatable {
            
            /// Parse name of this frame, e.g. `"clrrvr01.pcx"`
            let frameName: String
            
            /// If all frames of all blocks of this `.def` file where flattened, this is the global index of this frame in that flattened list.
            let globalFrameId: Int
            
            /// The index of the block, from which this frame was parsed.
            let blockId: Int
            
            /// The index of this frame inside its block.
            let frameIdInBlock: Int
            
            /// The expected SHA256 hash of the pixeldata for this frame.
            let hash: String
        }
    }
}

final class ParsingOfH3spriteArchiveTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    // will take ~40 sec on 2019 MBP if we load all def files...
    // For the 17 def files of interest it takes 0.7 seconds
    func test__H3sprite_lod__parsing() throws {
        let config = try Config()
        let assetsProvider = AssetsProvider(config: config)
        let spriteLodFile = try assetsProvider.open(archive: .lod(.restorationOfErathiaSpriteArchive))
        let spriteLodName = "H3sprite.lod"
        
        let testVectorURL = try XCTUnwrap(Bundle.module.url(forResource: "ExpectedHashesOfDefFilesInArchive__H3sprite_lod", withExtension: "json"))
        let testVectorData = try Data(contentsOf: testVectorURL)
        let jsonDecoder = JSONDecoder()
        let expectedHashesOfArchive = try jsonDecoder.decode(ExpectedHashesOfArchive.self, from: testVectorData)
        XCTAssertEqual(expectedHashesOfArchive.archive, spriteLodName)
        
        var setOfExpectedHashesToFulFill = Set<String>(expectedHashesOfArchive.hashesOfDefFiles.flatMap({ def in def.hashesOfFrames.map { frame in frame.hash } }))
        
        let defFilesInTestVector = expectedHashesOfArchive.hashesOfDefFiles.map { $0.defFileName }.map { $0.lowercased() }

        XCTAssertEqual(defFilesInTestVector, [
            "clrrvr.def",
            "cobbrd.def",
            "dirtrd.def",
            "dirttl.def",
            "grastl.def",
            "gravrd.def",
            "icyrvr.def",
            "lavatl.def",
            "lavrvr.def",
            "mudrvr.def",
            "rocktl.def",
            "rougtl.def",
            "sandtl.def",
            "snowtl.def",
            "subbtl.def",
            "swmptl.def",
            "watrtl.def"
        ])
        
        let expectedHashes = Dictionary<String, String>(
            uniqueKeysWithValues: expectedHashesOfArchive.hashesOfDefFiles
                .flatMap({ def in
                    def.hashesOfFrames.map { frame in
                        (
                            key: frame.frameName.lowercased(),
                            value: frame.hash
                        )
                    }
                })
        )
        
        XCTAssertEqual(spriteLodFile.fileName, spriteLodName)
        
//        let expectRepeatingSegmentFragmentsEncodingEachLineIndividually = expectation(description: "repeatingSegmentFragmentsEncodingEachLineIndividually")
//        expectRepeatingSegmentFragmentsEncodingEachLineIndividually.assertForOverFulfill = false
        
        let expectRepeatingSegmentFragments = expectation(description: "repeatingSegmentFragments")
        expectRepeatingSegmentFragments.assertForOverFulfill = false
       
//        let expectRepeatingCodeFragment = expectation(description: "repeatingCodeFragment")
//        expectRepeatingCodeFragment.assertForOverFulfill = false
        
        let expectNonCompressed =  expectation(description: "nonCompressed")
        expectNonCompressed.assertForOverFulfill = false
        
        let parser = LodParser()
        let defParserInspector: DefParser.Inspector = .init(onParseFrame: { frame in
//            if frame.fileName.lowercased() == "TRDC000.pcx".lowercased() {
//                print("cobble stone that app fails to draw: \(String.init(describing: frame))")
//                print("cobble stone that app fails to draw: \(String.init(describing: frame))")
//            }
            switch frame.encodingFormat {
            case .repeatingSegmentFragmentsEncodingEachLineIndividually:
//                expectRepeatingSegmentFragmentsEncodingEachLineIndividually.fulfill()
                break
            case .repeatingSegmentFragments:
                expectRepeatingSegmentFragments.fulfill()
            case .repeatingCodeFragment:
                break
//                expectRepeatingCodeFragment.fulfill()
            case .nonCompressed:
                expectNonCompressed.fulfill()
            }
            
        })
        let inspector = AssetParsedInspector(onParseFileEntry: { entry in
            XCTAssertEqual(entry.parentArchiveName, spriteLodName)
            guard let lodFileEntry = entry as? LodFile.FileEntry else {
                XCTFail("Wrong fileEntry type.")
                return
            }
            guard case .def(let definitionLoader) = lodFileEntry.content else {
                return
            }
            
            guard defFilesInTestVector.contains(lodFileEntry.fileName.lowercased()) else {
                return
            }
            
            let definitionFile = definitionLoader(defParserInspector)
            XCTAssertEqual(definitionFile.parentArchiveName, spriteLodName)
            definitionFile.blocks.enumerated().forEach({ (blockIndex, block) in
                block.frames.enumerated().forEach({ (frameIndex, frame) in
                    let frameName = frame.fileName.lowercased()
                    guard let expectedHash = expectedHashes[frameName] else {
                        fatalError("Failed to retrieve expected hash for frame named: '\(frameName)'")
                    }
                    
                    let sha256 = sha256Hex(frame.pixelData)
                    XCTAssertEqual(expectedHash, sha256)
                    setOfExpectedHashesToFulFill.remove(sha256)
                })
            })
            
        })
        let spriteLod = try parser.parse(archiveFile: spriteLodFile, inspector: inspector)
        XCTAssertEqual(spriteLod.entries.count, 4013)
        XCTAssertTrue(setOfExpectedHashesToFulFill.isEmpty)
        waitForExpectations(timeout: 1)
    }
}

func sha256Hex(_ data: Data, uppercase: Bool = false) -> String {
    var hasher = SHA256()
    hasher.update(data: data)
    let digest = Data(hasher.finalize())
    return digest.hexEncodedString(options: uppercase ? Data.HexEncodingOptions.upperCase : [])
}
