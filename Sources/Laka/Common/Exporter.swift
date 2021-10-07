//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Malm

final class Exporter {
    typealias ExportToMany = (SimpleFile) throws -> [SimpleFile]
    typealias ExportToOne = (SimpleFile) throws -> SimpleFile
    
    private let exportToMany: ExportToMany
    
    private init(exportToMany: @escaping ExportToMany) {
        self.exportToMany = exportToMany
    }
    
    static func exportingMany(_ exportToMany: @escaping ExportToMany) -> Exporter {
        .init(exportToMany: exportToMany)
    }
    
    static func exportingOne(_ exportToOne: @escaping ExportToOne) -> Exporter {
        .init { toExport in
            try [exportToOne(toExport)]
        }
    }
    
    func export(_ simpleFile: SimpleFile) throws -> [SimpleFile] {
        try exportToMany(simpleFile)
    }
}

