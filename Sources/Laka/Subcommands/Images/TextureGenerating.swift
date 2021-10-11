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
        maxImageCountPerDefFile: Int?
    ) throws
}

extension TextureGenerating {
    
    var fileManager: FileManager { .default }
    
    func makeAggregator(atlasName: String) -> Aggregator<ImageFromFrame> {
        
        return Aggregator<ImageFromFrame> { (images: [ImageFromFrame]) throws -> [File] in
            precondition(!images.isEmpty)

            let packer = Packer()
            
            let packedCanvas = try packer.sync.pack(
                packables: images,
                sorting: .byArea
            )
            
            let packedImages = packedCanvas.packed
            
            var transparentPixels: [Palette.Pixel] = .init(
                repeating: Palette.transparentPixel,
                count: .init(packedCanvas.canvasSize.area)
            )
            
            guard let context = CGContext.from(
                pixelPointer: &transparentPixels,
                width: .init(packedCanvas.canvasSize.width),
                height: .init(packedCanvas.canvasSize.height)
            ) else {
                incorrectImplementation(
                    shouldAlwaysBeAbleTo: "Create a CGContext. Please check for inconsistencies between `width*height` and `transparentPixels.count` and possibly colorSpace/bitmapInfo values."
                )
            }
            
            let meta: FramesInAtlas.Meta = .init(
                atlasName: atlasName,
                colorSpace: context.colorSpace!,
                size: packedCanvas.canvasSize
            )
            
            var framesInAtlas = FramesInAtlas(meta: meta)
            
            for image in packedImages {
                let sourceRect = image.content.rect
                
                let rectInAtlas = CGRect(origin: image.positionOnCanvas, size: sourceRect.size)
                
                let cropToRect: CGRect? = image.content.rect.size == image.content.fullSize ? nil : image.content.rect
                
                // It is very unfortunate but CGRect.draw seems to begin drawing
                // in the BOTTOM left corner, We correct this my mirroring the
                // origin by the Y axis.
                context.nonYMirroredDraw(
                    image: image.content.cgImage,
                    in: rectInAtlas,
                    cropToRect: cropToRect,
                    onCanvasOfHeight: packedCanvas.canvasSize.height
                )
                
                framesInAtlas.add(
                    frame: .init(
                        name: image.content.name,
                        sourceRect: sourceRect,
                        fullSize: .init(width: .init(image.content.fullSize.width), height: .init(image.content.fullSize.height)),
                        rectInAtlas: .init(origin: image.positionOnCanvas, size: sourceRect.size)
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
        atlasName: String,
        defFileName: String,
        nameFromFrameAtIndexIndex: @escaping ((DefinitionFile.Frame, Int) throws -> String?) = { f, i in f.fileName }
    ) throws {
        try generateTexture(
            name: atlasName,
            list: [
                .init(
                    defFileName: defFileName,
                    nameFromFrameAtIndexIndex: nameFromFrameAtIndexIndex
                )
            ]
        )
    }
    
    func generateTexture(
        name atlasName: String,
        list fileList: [ImageExport],
        maxImageCountPerDefFile: Int? = nil
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
                if let imageCountPerFile = maxImageCountPerDefFile{
                    return unparsedDefFles.count * imageCountPerFile
                } else {
                    return try unparsedDefFles.map { try defParser.peekFileEntryCount(of: $0) }.reduce(0, +)
                }
            },
            
            exporter: defParser.exporter(
                fileList: fileList,
                maxImageCountPerDefFile: maxImageCountPerDefFile
            ),
            
            aggregator: makeAggregator(atlasName: atlasName)
        )
        
    }
}
