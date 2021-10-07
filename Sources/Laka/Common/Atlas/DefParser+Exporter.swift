//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Guld
import Malm

extension DefParser {
    
    func exporter(
        fileList: [ImageExport],
        limit: Int? = nil
    ) -> Exporter<ImageFromFrame> {
        
        .exportingMany { [self] toExport in
            
            let defFile = try parse(
                data: toExport.data,
                definitionFileName: toExport.name
            )
            
            guard let imageToExportFileTemplate = fileList.first(where: { $0.defFileName == toExport.name }) else {
                throw Fail(description: "Expected to find name in list")
            }
            
            return try defFile.entries.prefix(limit ?? defFile.entries.count).enumerated().map { (frameIndex, frame) in
                let imageName = imageToExportFileTemplate.nameFromFrameIndex(frameIndex)
                let cgImage = try ImageImporter.imageFrom(frame: frame, palette: defFile.palette)
                return ImageFromFrame(name: imageName, cgImage: cgImage, fullSize: frame.fullSize, rect: frame.rect)
            }
        }
    }
}
