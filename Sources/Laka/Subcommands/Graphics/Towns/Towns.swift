//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

import ArgumentParser
import Guld
import Malm
import Common

extension Laka {
    
    /// A command to extract in town game menu such as background and buildings.
    struct Towns: CMD, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in town game menu such as background and buildings."
        )
        
        @OptionGroup var options: Options
        
        
        static let executionOneLinerDescription = "🏘  Extracting all town UI"
        static let optimisticEstimatedRunTime: TimeInterval = 10
        
        /// Requires `Laka lod` to have been run first.
        func extract() throws {
            try exportTown(template: .castle)
        }
    }
}

// MARK: Computed Props
internal extension Laka.Towns {
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: options.outputPath)
        .appendingPathComponent("Converted")
        .appendingPathComponent("Graphics")
        .appendingPathComponent("Towns")
    }

}

 
// MARK: Private
private extension Laka.Towns {
    
    func exportTown<BuildingKind: BuildingIDForFaction>(template: TownTemplate<BuildingKind>) throws {
        let fileMatrix: [[ImageExport]] = [
            [
                .pcx(.init(pcxImageName: template.townBackground.lowercased())),
                .pcx(.init(pcxImageName: template.creatureBackground.lowercased()))
            ],
            template.buildings.flatMap({ (buildingID: BuildingKind, building: TownTemplate<BuildingKind>.BuildingDetails) -> [ImageExport] in
                return [
                    .def(
                        DefImageExport(
                            defFileName: building.gfx.animation.lowercased(),
                            nameFromFrameAtIndexIndex: { _, frameIndex in "\(buildingID.name)_\(frameIndex)" }
                        )
                    ),
                    .pcx(.init(pcxImageName: building.gfx.border.lowercased()))
                ]
            }),
            template.animations.map({ animation in
                return .def(
                    DefImageExport(
                        defFileName: animation.gfx.lowercased(),
                        nameFromFrameAtIndexIndex: { frame, frameIndex in "\(frame.fileName)_\(frameIndex)" }
                    )
                )
            })
        ]
        
        let fileList: [ImageExport] = fileMatrix.flatMap { $0 }
        
        return try generateTexture(
            name: "town_\(template.faction)",
            list: fileList,
//            didCalculateWorkLoad: { self.report(numberOfEntriesToExtract: $0) },
            finishedExportingOneEntry: self.finishedExtractingEntry
        )
        
    }
}
