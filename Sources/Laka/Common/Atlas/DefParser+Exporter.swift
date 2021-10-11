//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Guld
import Malm
import Util

extension DefParser {
    
    func exporter(
        fileList: [ImageExport],
        maxImageCountPerDefFile: Int? = nil
    ) -> Exporter<ImageFromFrame> {
        
        .exportingMany { [self] toExport in
            
            let defFile = try parse(
                data: toExport.data,
                definitionFileName: toExport.name
            )
            
            guard let imageToExportFileTemplate = fileList.first(where: { $0.defFileName == toExport.name }) else {
                throw Fail(description: "Expected to find name in list")
            }
            
            return try defFile.entries.prefix(maxImageCountPerDefFile ?? defFile.entries.count).enumerated().compactMap { (frameIndex, frame) in
                guard let imageName = imageToExportFileTemplate.nameFromFrameAtIndexIndex(frame, frameIndex) else {
                    // Skip frame, since it is deemed irrelevant.
                    return nil
                }
                let cgImage = try ImageImporter.imageFrom(frame: frame, palette: defFile.palette)
                return ImageFromFrame(name: imageName, cgImage: cgImage, fullSize: frame.fullSize, rect: frame.rect)
            }
        }
    }
}
