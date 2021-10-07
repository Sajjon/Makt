//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Malm
import Guld

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
        return Aggregator<ImageFromFrame> { (images: [ImageFromFrame]) -> [File] in
            precondition(!images.isEmpty)
            
            let singleWidth = images[0].fullSize.width
            let singleHeight = images[0].fullSize.height
            
            let columnCount = Int(sqrt(Double(images.count)).rounded(.up))
            let rowCount = Int((Double(images.count)/Double(columnCount)).rounded(.up))
            
            let atlasWidth = Int(singleWidth) * columnCount
            let atlasHeight = rowCount * Int(singleHeight)
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
            
            let sortedImages = images.sorted(by: \.name)
            
            for (imageIndex, image) in sortedImages.enumerated() {
                let (rowIndex, columnIndex) = imageIndex.quotientAndRemainder(dividingBy: columnCount)
                let x =  CGFloat(columnIndex) * singleWidth
                let y = CGFloat(rowIndex) * singleHeight
                
                let width = image.fullSize.width
                assert(width == singleWidth)
                
                let height = image.fullSize.height
                assert(height == singleHeight)
                
                let rectInAtlas = CGRect(
                    x: x,
                    y: y,
                    width: width,
                    height: height
                )
                
                context.draw(
                    image.cgImage,
                    in: rectInAtlas
                )
                
                framesInAtlas.add(
                    frame: .init(
                        name: image.name,
                        sourceRect: image.rect,
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
