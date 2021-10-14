//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Guld

protocol Exportable {
    static var listOfFilesToExport: [DefImageExport] { get }
}

protocol DefFileNameConvertible {
    var defFileName: String { get }
}

protocol FileNaming {
    var name: String { get }
    static var namePrefix: String { get }
    static var fileExtension: String { get }
}

protocol PNGExportable: Exportable & DefFileNameConvertible & FileNaming {}

extension PNGExportable {
    static var fileExtension: String { "png" }
}

extension PNGExportable where Self: CaseIterable, AllCases == [Self] {
    var imageExport: DefImageExport {
        .init(defFileName: defFileName) { _, frameIndex in
            [
                [
                    Self.namePrefix,
                    name,
                    String(describing: frameIndex)
                ].joined(separator: "_"),
                Self.fileExtension
                
            ].joined(separator: ".")
        }
    }
    
    static var listOfFilesToExport: [DefImageExport]  { Self.allCases.map { $0.imageExport } }
}

struct DefImageExport {
    let defFileName: String
    
    /// Returning `nil` means that the frame should be skipped
    let nameFromFrameAtIndexIndex: (_ frame: DefinitionFile.Frame, _ frameIndex: Int) throws -> String?
}

struct PCXImageExport {
    let pcxImageName: String
}

enum ImageExport {
    case def(DefImageExport)
    case pcx(PCXImageExport)
    
    var fileName: String {
        switch self {
        case .def(let def): return def.defFileName
        case .pcx(let pcx): return pcx.pcxImageName
        }
    }
    
    var asDef: DefImageExport? {
        switch self {
        case .def(let def): return def
        case .pcx: return nil
        }
    }
    
    var asPcx: PCXImageExport? {
        switch self {
        case .def: return nil
        case .pcx(let pcx): return pcx
        }
    }
}
