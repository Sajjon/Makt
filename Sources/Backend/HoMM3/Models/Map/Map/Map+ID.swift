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

        public let fileName: String
        
        public init(fileName: String) {
            guard let fileExtension = fileName.fileExtension else {
                preconditionFailure("Uknown file extension of map named: \(fileName)")
            }
            precondition(Self.supportedFileExtensions.contains(fileExtension))
            self.fileName = fileName
        }
    }
}

// MARK: ExpressibleByStringLiteral
extension Map.ID: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral fileName: StringLiteralType) {
        self.init(fileName: fileName)
    }
}

// MARK: Public
public extension Map.ID {
    static let fileExtensionTutorialMap = "tut"
    static let fileExtension = "h3m"
    static let supportedFileExtensions = [Self.fileExtension, Self.fileExtensionTutorialMap]
}


private extension String {
    var fileExtension: String? {
        guard let fileExtensionComponent = split(separator: ".").last else {
            return nil
        }
        return String(fileExtensionComponent)
    }
}
