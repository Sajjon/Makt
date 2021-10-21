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
import Common

protocol TextureGenerating {
    var inDataURL: URL { get }
    var outImagesURL: URL { get }
    var fileManager: FileManager { get }
    
    func generateTexture(
        name atlasName: String?,
        list fileList: [ImageExport],
        usePaletteReplacementMap: Bool,
        skipImagesWithSameNameAndData: Bool,
        maxImageCountPerDefFile: Int?,
        didCalculateWorkLoad: ((Int) -> Void)?,
        finishedExportingOneEntry: (() -> Void)?
    ) throws
}

extension TextureGenerating {
    
    var fileManager: FileManager { .default }
    
    func makeAggregator(atlasName: String, skipImagesWithSameNameAndData: Bool = false) -> Aggregator<ImageFromFrame> {
        
        return Aggregator<ImageFromFrame> { (possiblyDuplicatedImages: [ImageFromFrame]) throws -> [File] in
            precondition(!possiblyDuplicatedImages.isEmpty, "list of images cannot be empty. Cannot aggregate an empty list of images.")
            
            var images: [ImageFromFrame] = []
            
            if skipImagesWithSameNameAndData {
                for image in possiblyDuplicatedImages {
                    if let prev = images.first(where: { $0.name == image.name }) {
                        if prev.data == image.data {
                            logger.debug("💡 Avoding image duplicate named: '\(image.name)' in atlas: '\(atlasName)' (same data too)")
                            // Avoid duplicate
                            continue
                        } else {
                            let duplicateCount = images.filter({ $0.name.contains(image.name) }).count
                            // Retain, but rename
                            let newUniqueName = "duplicate_\(duplicateCount)_\(image.name)"
                            logger.debug("⚠️ WARNING image with duplicate name, but unique data, retaining it, but renaming it\nfrom: '\(image.name)'\nto: '\(newUniqueName)'")
                            let modifiedName = ImageFromFrame(name: newUniqueName, cgImage: image.cgImage, fullSize: image.fullSize, rect: image.rect)
                            images.append(modifiedName)
                        }
                    } else {
                        // Retain as is
                        images.append(image)
                    }
                }
            } else {
                images = possiblyDuplicatedImages
            }

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
        skipImagesWithSameNameAndData: Bool = false,
        maxImageCountPerDefFile: Int? = nil,
        nameFromFrameAtIndexIndex: @escaping ((DefinitionFile.Frame, Int) throws -> String?) = { f, i in f.fileName }
    ) throws {
        try generateTexture(
            name: atlasName,
            list: [
                .def(.init(
                    defFileName: defFileName,
                    nameFromFrameAtIndexIndex: nameFromFrameAtIndexIndex
                ))
            ],
            skipImagesWithSameNameAndData: skipImagesWithSameNameAndData,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }

    
    func generateTexture(
        name atlasName: String?,
        list fileList: [ImageExport],
        usePaletteReplacementMap: Bool = true,
        skipImagesWithSameNameAndData: Bool = false,
        maxImageCountPerDefFile: Int? = nil,
        
        didCalculateWorkLoad: ((Int) -> Void)? = nil,
        finishedExportingOneEntry: (() -> Void)? = nil
    ) throws {
        let fileNameList = fileList.map{ $0.fileName }
        logger.debug("⚙️ Generating \(atlasName.map{ "\($0) " } ?? "")texture.")
        
        let defParser = DefParser()
        let defFileList = fileList.compactMap {
            $0.asDef
        }
        let pcxFileList = fileList.compactMap {
            $0.asPcx
        }
        
        let defParseExporter = defParser.exporter(
            fileList: defFileList,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
        
        let lodParser = LodParser()
        
        let pcxImageExporter: Exporter<ImageFromFrame> = .exportingOne { toExport in
            let pcx = try lodParser.parsePCX(from: toExport.data, named: toExport.name)
            let cgImage = try ImageImporter.imageFrom(pcx: pcx, usePaletteReplacementMap: usePaletteReplacementMap)
            
            return ImageFromFrame(
                name: atlasName!,
                cgImage: cgImage,
                fullSize: pcx.size,
                rect: pcx.rect
            )
        }
        
        let maybeAggregator: Aggregator<ImageFromFrame>? = (defFileList.count > 0 || pcxFileList.count > 1) ? atlasName.map { makeAggregator(atlasName: $0, skipImagesWithSameNameAndData: skipImagesWithSameNameAndData) } : nil
        
     
        try fileManager.export(
            target: .specificFileList(fileNameList),
            at: inDataURL,
            to: outImagesURL,
//            filesToExportHaveBeenRead: { unparsedFiles in
//                let count: Int = {
//                    if let imageCountPerFile = maxImageCountPerDefFile {
//                        return unparsedFiles.count * imageCountPerFile
//                    } else if defFileList.count > 0 {
//                        return unparsedFiles.map { unparseFile -> Int in
//                            let entryCount: Int = (try? defParser.peekFileEntryCount(of: unparseFile)) ?? 0
//                            return entryCount
//                        }.reduce(0, +)
//                    } else {
//                        return pcxFileList.count
//                    }
//                }()
//                didCalculateWorkLoad?(count)
//                return count
//            },
            exporter: .exportingMany { toExport in
                if toExport.name.hasSuffix(".pcx") {
                    let exported = try pcxImageExporter.export(toExport)
//                    _  = exported.count.nTimes {
                        finishedExportingOneEntry?()
//                    }
                    return exported
                } else if toExport.name.hasSuffix(".def") {
                    let exported = try defParseExporter.export(toExport)
//                    _  = exported.count.nTimes {
                        finishedExportingOneEntry?()
//                    }
                    return exported
                } else {
                    incorrectImplementation(reason: "Unsupported file format, file named: \(toExport.name)")
                }
                
            },
            
            aggregator: maybeAggregator
        )
        
    }
    
    
    func generateTexture(
        imageName: String,
        pcxImageName: String,
        usePaletteReplacementMap: Bool = true
    ) throws {
        try generateTexture(
            name: imageName,
            list: [.pcx(.init(pcxImageName: pcxImageName))],
            usePaletteReplacementMap: usePaletteReplacementMap
        )
    }

}
