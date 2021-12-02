//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-21.
//

import Foundation

// MARK: Task
struct GenerateAtlasTask: SubTask {
   
    let taskName: String
    let filelist: [ImageExport]
    let atlasName: String
    let maxImageCountPerDefFile: Int?
    let usePaletteReplacementMap: Bool
    let skipImagesWithSameNameAndData: Bool
    
    init(
        name: String? = nil,
        atlasName: String,
        filelist: [ImageExport],
        usePaletteReplacementMap: Bool = true,
        maxImageCountPerDefFile: Int? = nil,
        skipImagesWithSameNameAndData: Bool = false
    ) {
        self.taskName = name ?? atlasName
        self.atlasName = atlasName
        self.filelist = filelist
        self.maxImageCountPerDefFile = maxImageCountPerDefFile
        self.usePaletteReplacementMap = usePaletteReplacementMap
        self.skipImagesWithSameNameAndData = skipImagesWithSameNameAndData
    }
}

extension GenerateAtlasTask {
    
    var entryCount: Int { filelist.count }
    
    init(
        name: String? = nil,
        atlasName: String,
        defFileList: [DefImageExport],
        maxImageCountPerDefFile: Int? = nil,
        skipImagesWithSameNameAndData: Bool = false
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            filelist: defFileList.map { .def($0) },
            maxImageCountPerDefFile: maxImageCountPerDefFile,
            skipImagesWithSameNameAndData: skipImagesWithSameNameAndData
        )
    }
    
    
    init(
        name: String? = nil,
        atlasName: String,
        defFile: DefImageExport,
        maxImageCountPerDefFile: Int? = nil,
        skipImagesWithSameNameAndData: Bool = false
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            defFileList: [defFile],
            maxImageCountPerDefFile: maxImageCountPerDefFile,
            skipImagesWithSameNameAndData: skipImagesWithSameNameAndData
        )
    }
    
    init(
        name: String? = nil,
        atlasName: String,
        pcxFiles: [PCXImageExport],
        usePaletteReplacementMap: Bool = true,
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            filelist: pcxFiles.map { .pcx($0) },
            usePaletteReplacementMap: usePaletteReplacementMap,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
    
    init(
        name: String? = nil,
        atlasName: String,
        pcxFile: PCXImageExport,
        usePaletteReplacementMap: Bool = true,
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            pcxFiles: [pcxFile],
            usePaletteReplacementMap: usePaletteReplacementMap,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
    
    
    init(
        name: String? = nil,
        atlasName: String,
        pcxFileName: String,
        usePaletteReplacementMap: Bool = true,
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            pcxFile: .init(pcxImageName: pcxFileName),
            usePaletteReplacementMap: usePaletteReplacementMap,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
    
    
    init(
        name: String? = nil,
        atlasName: String,
        defList: [String],
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            defFileList: defList.map { defFileName in .init(defFileName: defFileName, nameFromFrameAtIndexIndex: { _, _ in defFileName }) },
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
    
    init(
        name: String? = nil,
        atlasName: String,
        defFileName: String,
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            defList: [defFileName],
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
}
