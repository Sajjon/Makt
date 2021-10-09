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
            
            let maxWidthOfAllImages = images.map { $0.fullSize.width }.max()!
            let maxHeightOfAllImages = images.map { $0.fullSize.height }.max()!
            
            let columnCount = sqrt(Double(images.count)).rounded(.up)
            let rowCount = (Double(images.count)/Double(columnCount)).rounded(.up)
            
            let margin = 1.1 // 10 % margin
            let atlasWidth = Int(maxWidthOfAllImages * columnCount * margin)
            let atlasHeight = Int(maxHeightOfAllImages * rowCount * margin)
            let atlasPixelCount = atlasWidth * atlasHeight
            
            var transparentPixels: [Palette.Pixel] = .init(
                repeating: Palette.transparentPixel,
                count: atlasPixelCount
            )
            
            let context = CGContext.from(
                pixelPointer: &transparentPixels,
                width: atlasWidth,
                height: atlasHeight
            )!
            
            let meta: FramesInAtlas.Meta = .init(
                atlasName: atlasName,
                colorSpace: context.colorSpace!,
                size: .init(width: atlasWidth, height: atlasHeight)
            )
            
            var framesInAtlas = FramesInAtlas(meta: meta)
            
////            let sortedImages = images.sorted(by: \.fullSize)
//            let packedImagesResult = try Alpacka.pack(
//                images,
//                origin: \.packedOrigin,
//                in: Alpacka.Size(w: Double(atlasWidth), h: Double(atlasHeight))
//            ).syncSink()
//
//
//            let packedImages: [ImageFromFrame]
//
//            switch packedImagesResult {
//            case .overFlow(_, let overFlow):
//                throw Fail(description: "Failed to fit all images inside rect: width: \(atlasWidth), height: \(atlasHeight) without overflow: \(overFlow.map { $0.rect })")
//            case .packed(let packed):
//                packedImages = packed
//            }
            
            
            let fittedImages = try syncPack(packables: images)
            let packedImages = fittedImages.packed
            
//            var aggregatedY: CGFloat = 0
            for image in packedImages {
//                let (rowIndex, columnIndex) = imageIndex.quotientAndRemainder(dividingBy: columnCount)
//
//                let referenceWidth = //maxWidthOfAllImages
//                let referenceHeight = //maxWidthOfAllImages
//
//                let x = CGFloat(columnIndex) * referenceWidth
//                let y = aggregatedY //CGFloat(rowIndex) * referenceHeight
//
//                if columnIndex == columnCount {
//                    aggregatedY += referenceHeight
//                }
//
//                let width = image.fullSize.width
//                assert(width <= referenceWidth)
//
//                let height = image.fullSize.height
//                assert(height <= referenceHeight)
//
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
            
            let mergedCGImage = context.makeImage()!
            
            let aggregatedImageFile = SimpleFile(
                name: "\(atlasName).png",
                data: mergedCGImage.png!
            )
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let framesInAtlasJSONData = try jsonEncoder.encode(framesInAtlas)
            let aggregatedImageFileMetaData = SimpleFile(name: "\(atlasName).json", data: framesInAtlasJSONData)
            
            return [
                aggregatedImageFile,
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
