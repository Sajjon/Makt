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

/*
 {
     "meta": {
         "image": "edges.png",
         "format": "RGBA8888",
         "size":
         {
             "w": 192,
             "h": 192
         },
         "scale": 1
     },

     "frames": {
         
         "edge_18.png": {
             "frame":
             {
                 "x": 0,
                 "y": 0,
                 "w": 32,
                 "h": 32
             },
             "rotated": false,
             "trimmed": false,
             "spriteSourceSize":
             {
                 "x": 0,
                 "y": 0,
                 "w": 32,
                 "h": 32
             },
             "sourceSize":
             {
                 "w": 32,
                 "h": 32
             }
         },
 */
//struct FramesInAtlas: Codable {
//    struct Frame: Codable {
//        let name: String
//        let trimmed: Bool
//        let spriteSourceSize: CGRect
//        let sourceSize: CGSize
//        init(frame: DefinitionFile.Frame, rect: CGRect) {
//            self.name = frame.fileName
//            self.trimmed = rect.width != frame.re  //file.width !== file.item.fullWidth || file.height !== file.item.fullHeight,
//            self.spriteSourceSize = frame.rect
//            self.sourceSize = frame.fullSize
//        }
//    }
//    struct Meta: Codable {
//        let image: String
//        let format: String
//        init(atlasName: String, colorSpace: CGColorSpaceCreateDeviceRGB) {
//
//        }
//    }
//    let meta: Meta
//    private var frames: [Frame]
//    init(meta: Meta) {
//        self.meta = meta
//        self.frames = []
//    }
//    mutating func add(frame: Frame) {
//        frames.append(frame)
//    }
//}


// MARK: Export
import Malm
import Util
private extension Laka.Textures {
    
    var roadFiles: [ImageExport] {
        Map.Tile.Road.Kind.listOfFilesToExport
    }
    var groundFiles: [ImageExport] {
        Map.Terrain.listOfFilesToExport
    }
    var riverFiles: [ImageExport] {
        Map.Tile.River.Kind.listOfFilesToExport
    }
    
    
    func exportTerrain() throws {
        
        try generateTexture(
            name: "terrain",
            list: roadFiles + riverFiles + groundFiles
        )
    }
    
    func generateTexture(
        name atlasName: String,
        list fileList: [ImageExport]
    ) throws {
        let defFileList = fileList.map{ $0.defFileName }
        print("⚙️ Generating \(atlasName) texture.")
        
        let verbose = parentOptions.printDebugInformation
        
        let defParser = DefParser()
        
        let aggregator = Aggregator<ImageFromFrame> { (images: [ImageFromFrame]) -> [File] in
            precondition(!images.isEmpty)
            
            let singleWidth = images[0].fullSize.width
            let singleHeight = images[0].fullSize.height

            let columnCount = Int(sqrt(Double(images.count)).rounded(.up))
            let rowCount = Int((Double(images.count)/Double(columnCount)).rounded(.up))
            assert(columnCount == rowCount)
            
            let atlasWidth = Int(singleWidth) * columnCount
            let atlasHeight = rowCount * Int(singleHeight)
            assert(atlasHeight == atlasWidth)
            let atlasPixelCount = atlasWidth * atlasHeight
            
            var transparentPixels: [Palette.Pixel] = .init(repeating: Palette.transparentPixel, count: atlasPixelCount)
            
            let context = CGContext.from(pixelPointer: &transparentPixels, width: atlasWidth, height: atlasHeight)!
            
            for (imageIndex, image) in images.enumerated() {
                let (rowIndex, columnIndex) = imageIndex.quotientAndRemainder(dividingBy: columnCount)
                let x =  CGFloat(columnIndex) * singleWidth
                let y = CGFloat(rowIndex) * singleHeight
                
                let width = image.fullSize.width
                assert(width == singleWidth)
                
                let height = image.fullSize.height
                assert(height == singleHeight)
                
                context.draw(
                    image.cgImage,
                    in: .init(
                        x: x,
                        y: y,
                        width: width,
                        height: height
                    )
                )
            }
   
            let mergedCGImage = context.makeImage()!
            
            let aggregatedImageFile = SimpleFile(name: "\(atlasName).png", data: mergedCGImage.png!)
            
            return [aggregatedImageFile]
            
        }
        
        try fileManager.export(
            target: .specificFileList(defFileList),
            at: inDataURL,
            to: outImagesURL,
            verbose: verbose,
            calculateWorkload: { unparsedDefFles in
                try unparsedDefFles.map { try defParser.peekFileEntryCount(of: $0) }.reduce(0, +)
            },
            exporter: defParser.exporter(fileList: fileList),
            aggregator: aggregator
        )
        
    }
}

struct ImageFromFrame: File {
    let name: String
    let cgImage: CGImage
    let fullSize: CGSize
    let rect: CGRect
    var data: Data {
        let data = cgImage.png!
        return data
    }
    
}

extension DefParser {
    
    func exporter(fileList: [ImageExport]) -> Exporter<ImageFromFrame> {
        .exportingMany { [self] toExport in
            
            let defFile = try parse(data: toExport.data, definitionFileName: toExport.name)
            guard let imageToExportFileTemplate = fileList.first(where: { $0.defFileName == toExport.name }) else {
                throw Fail(description: "Expected to find name in list")
            }
            
            return try defFile.entries.enumerated().map { (frameIndex, frame) in
                let imageName = imageToExportFileTemplate.nameFromFrameIndex(frameIndex)
                let cgImage = try ImageImporter.imageFrom(frame: frame, palette: defFile.palette)
                return ImageFromFrame(name: imageName, cgImage: cgImage, fullSize: frame.fullSize, rect: frame.rect)
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

// MARK: River + PNGExportable
extension Map.Tile.River.Kind: PNGExportable {
    var defFileName: String {
        switch self {
            case .clear: return "clrrvr.def"
            case .icy: return "icyrvr.def"
            case .muddy: return "mudrvr.def"
            case .lava: return "lavrvr.def"
        }
    }
    
    static var namePrefix: String { "river" }
}

// MARK: Road + PNGExportable
extension Map.Tile.Road.Kind: PNGExportable {
    var defFileName: String {
        switch self {
        case .dirt: return "dirtrd.def"
        case .gravel: return "gravrd.def"
        case .cobbelStone: return "cobbrd.def"
        }
    }
    
    static var namePrefix: String { "road" }
}
