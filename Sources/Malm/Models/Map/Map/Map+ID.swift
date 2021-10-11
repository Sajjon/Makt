//
//  Map+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    
    /// A stable identifier of a map.
    struct ID: Hashable {
        
        public let file: File
        
        public init(file: File) {
            self.file = file
        }
        
        public init(named fileName: String) {
            guard let fileExtension = fileName.fileExtension else {
                preconditionFailure("Uknown file extension of map named: \(fileName)")
            }
            precondition(Self.supportedFileExtensions.contains(fileExtension))
            self.init(file: .relative(name: fileName))
        }
        
        public init(absolutePath: String) {
            guard let fileExtension = absolutePath.fileExtension else {
                preconditionFailure("Uknown file extension of map with path: \(absolutePath)")
            }
            precondition(Self.supportedFileExtensions.contains(fileExtension))
            self.init(file: .absolute(path: absolutePath))
        }
    }
}

// MARK: ExpressibleByStringLiteral
extension Map.ID: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral fileName: StringLiteralType) {
        self.init(named: fileName)
    }
}

// MARK: Public
public extension Map.ID {
    
    enum File: Hashable {
        case absolute(path: String)
        case relative(name: String)
    }
    
    var name: String {
        String(fileName.split(separator: ".").first!)
    }
    
    var fileName: String {
        switch file {
        case .relative(let name): return name
        case .absolute(let path): return String(path.split(separator: "/").last!)
        }
    }
    
  
    static let supportedFileExtensions = [Map.fileExtension, Map.fileExtensionTutorialMap]
}
