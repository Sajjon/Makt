//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Guld

protocol Exportable {
    static var listOfFilesToExport: [ImageExport] { get }
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
    var imageExport: ImageExport {
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
    
    static var listOfFilesToExport: [ImageExport]  { Self.allCases.map { $0.imageExport } }
}

struct ImageExport {
    let defFileName: String
    
    /// Returning `nil` means that the frame should be skipped
    let nameFromFrameAtIndexIndex: (_ frame: DefinitionFile.Frame, _ frameIndex: Int) -> String?
}
