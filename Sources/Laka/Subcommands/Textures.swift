//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import ArgumentParser
import Guld
import Malm
import Util
import Foundation

extension Laka {
    
    /// A command to extract all textures, such as terrain, monsters, artifacts,
    /// heroes and towns on the map etc. But not game menu UI, neither
    /// in combat/battle creature sprites nor in town UI.
    struct Textures: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
        )
        
        @OptionGroup var parentOptions: Options

    }
}

// MARK: Run
extension Laka.Textures {
    
    mutating func run() throws {
        
        print(
            """
            
            🔮
            About to extract textures from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about 30 seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        
        try exportTerrain()
    }
}

// MARK: Export
import Malm
import Util
private extension Laka.Textures {
    
    func exportTerrain() throws {
        
        try generateTexture(
            name: "Terrain",
            list: Map.Terrain.listOfFilesToExport
        )
    }
    
    func generateTexture(
        name: String,
        list fileList: [ImageExport]
    ) throws {
        let defFileList = fileList.map{ $0.defFileName }
        print("⚙️ Generating \(name) texture 🟩 🟨 ⬜️, defFileList: \(defFileList)")
        
        let verbose = parentOptions.printDebugInformation
        
        let defParser = DefParser()
        
        try fileManager.export(
            target: .specificFileList(defFileList),
            at: inDataURL,
            to: outImagesURL,
            verbose: verbose,
            calculateWorkload: { unparsedDefFles in
                try unparsedDefFles.map { try defParser.peekFileEntryCount(of: $0) }.reduce(0, +)
            },
            exporter: defParser.exporter(fileList: fileList)
        )
        
    }
}

extension DefParser {
    
    func exporter(fileList: [ImageExport]) -> Exporter {
        .exportingMany { [self] toExport in
            
            let defFile = try parse(data: toExport.data, definitionFileName: toExport.name)
            guard let imageToExportFileTemplate = fileList.first(where: { $0.defFileName == toExport.name }) else {
                throw Fail(description: "Expected to find name in list")
            }
            
            return try defFile.entries.enumerated().map { (frameIndex, frame) in
                try SimpleFile(
                    name: imageToExportFileTemplate.nameFromFrameIndex(frameIndex),
                    data: frame.exportablePNGImageData(palette: defFile.palette)
                )
            }
        }
    }
}


extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}


// MARK: Computed props
extension Laka.Textures {
    
    var fileManager: FileManager { .default }
    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("entries")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("images")
    }
}

extension DefinitionFile.Frame {
    func exportablePNGImageData(palette: Palette?) throws -> Data {
        let cgImage = try ImageImporter.imageFrom(frame: self, palette: palette)
        guard let pngData = cgImage.png else {
            throw Fail(description: "Failed to convert CGImage to PNG data.")
        }
        return pngData
    }
}

// MARK: Terrain + PNGExportable
extension Map.Terrain: PNGExportable {
    var defFileName: String {
        switch self {
        case .dirt: return "dirttl.def"
        case .sand: return "sandtl.def"
        case .grass: return "grastl.def"
        case .snow: return "snowtl.def"
        case .swamp: return "swmptl.def"
        case .rough: return "rougtl.def"
        case .subterranean: return "subbtl.def"
        case .lava: return "lavatl.def"
        case .water: return "watrtl.def"
        case .rock: return "rocktl.def"
        }
    }
    
    static var namePrefix: String { "ground" }

}
