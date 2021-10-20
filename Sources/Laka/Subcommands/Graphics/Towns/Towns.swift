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
import Util

extension Laka {
    
    /// A command to extract in town game menu such as background and buildings.
    struct Towns: CMD, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in town game menu such as background and buildings."
        )
        
        @OptionGroup var options: Options
        
        /// Requires `Laka lod` to have been run first.
        mutating func run() throws {
            print("🏘 Extracting all town UI, run time: ~10s")
            try exportAllUIForAllTowns()
        }
    }
}

// MARK: Computed Props
internal extension Laka.Towns {
    
    var verbose: Bool { options.printDebugInformation }
    
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
    func exportAllUIForAllTowns() throws {
        try exportTown(template: .castle)
    }
    
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
            skipCalculateWorkload: true
        )
        
    }
}
