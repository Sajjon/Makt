//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Malm

typealias SimpleFileExporter = Exporter<SimpleFile>

final class Exporter<Output: File> {
    typealias ExportToMany = (File) throws -> [Output]
    typealias ExportToOne = (File) throws -> Output
    
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
    
    func export(_ file: File) throws -> [Output] {
        try exportToMany(file)
    }
}
