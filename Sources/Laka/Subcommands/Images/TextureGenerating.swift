//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Malm
import Guld
import Packa
import Combine
import Util

protocol TextureGenerating {
    var inDataURL: URL { get }
    var outImagesURL: URL { get }
    var verbose: Bool { get }
    var fileManager: FileManager { get }
    
    func generateTexture(
        name atlasName: String,
        list fileList: [ImageExport],
        limit: Int?
    ) throws
}

extension TextureGenerating {
    
    func makeAggregator(atlasName: String) -> Aggregator<ImageFromFrame> {
        
        return Aggregator<ImageFromFrame> { (images: [ImageFromFrame]) throws -> [File] in
            precondition(!images.isEmpty)

            let packer = Packer()
            
            let canvasOfPackedImages = try packer.sync.pack(
                packables: images,
                sorting: .byArea
            )
            
            let packedImages = canvasOfPackedImages.packed
            
            var transparentPixels: [Palette.Pixel] = .init(
                repeating: Palette.transparentPixel,
                count: .init(canvasOfPackedImages.canvasSize.area)
            )
            
            guard let context = CGContext.from(
                pixelPointer: &transparentPixels,
                width: .init(canvasOfPackedImages.canvasSize.width),
                height: .init(canvasOfPackedImages.canvasSize.height)
            ) else {
                incorrectImplementation(shouldAlwaysBeAbleTo: "Create a CGContext. Please check for inconsistencies between `width*height` and `transparentPixels.count` and possibly colorSpace/bitmapInfo values.")
            }
            
            let meta: FramesInAtlas.Meta = .init(
                atlasName: atlasName,
                colorSpace: context.colorSpace!,
                size: canvasOfPackedImages.canvasSize
            )
            
            var framesInAtlas = FramesInAtlas(meta: meta)
            
   
            for image in packedImages {
                let packedX = image.positionOnCanvas.x
                let packedY = image.positionOnCanvas.y
                
                let rectInAtlas = CGRect(
                    x: packedX,
                    y: packedY,
                    width: image.content.width,
                    height: image.content.height
                )
                
                context.draw(
                    image.content.cgImage,
                    in: rectInAtlas
                )
                
                framesInAtlas.add(
                    frame: .init(
                        name: image.content.name,
                        sourceRect: image.content.rect,
                        rectInAtlas: rectInAtlas
                    )
                )
            }
            
            guard
                let atlasImage = context.makeImage(),
                let atlasImageAsPNGData = atlasImage.png
            else {
                throw Fail(description: "Failed ot create atlas of images.")
            }
            
            let atlasImageFile = SimpleFile(
                name: "\(atlasName).png",
                data: atlasImageAsPNGData
            )
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let framesInAtlasJSONData = try jsonEncoder.encode(framesInAtlas)
            let aggregatedImageFileMetaData = SimpleFile(name: "\(atlasName).json", data: framesInAtlasJSONData)
            
            return [
                atlasImageFile,
                aggregatedImageFileMetaData
            ]
            
        }
    }
    
    func generateTexture(
        name atlasName: String,
        list fileList: [ImageExport],
        limit: Int? = nil
    ) throws {
        let defFileList = fileList.map{ $0.defFileName }
        print("⚙️ Generating \(atlasName) texture.")
        
        let defParser = DefParser()
        
        try fileManager.export(
            target: .specificFileList(defFileList),
            at: inDataURL,
            to: outImagesURL,
            verbose: verbose,
            calculateWorkload: { unparsedDefFles in
                if limit != nil {
                    return unparsedDefFles.count
                } else {
                    return try unparsedDefFles.map { try defParser.peekFileEntryCount(of: $0) }.reduce(0, +)
                }
            },
            exporter: defParser.exporter(fileList: fileList, limit: limit),
            aggregator: makeAggregator(atlasName: atlasName)
        )
        
    }
}
