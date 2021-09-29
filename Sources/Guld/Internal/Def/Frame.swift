//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public extension DefinitionFile {
    
    /// A picture frame as part of a file defined in the defintion file
    struct Frame: Hashable, Identifiable {
        public typealias ID = String
        public var id: ID { fileName }
        public let fileName: String
        public let fullSize: CGSize
        public let rect: CGRect
        public let pixelData: Data
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.size)
        hasher.combine(self.origin)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
