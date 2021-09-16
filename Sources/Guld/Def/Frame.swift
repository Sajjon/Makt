//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public extension DefinitionFile {
    
    /// A picture frame as part of a file defined in the defintion file
    struct Frame: Hashable {
        public let fileName: String
        public let size: Int
        public typealias Scalar = Int
        public let fullWidth: Scalar
        public let fullHeight: Scalar
        public let width: Scalar
        public let height: Scalar
        public let margin: Margin
        public let pixelData: Data
        
        public struct Margin: Hashable {
            public let left: Scalar
            public let top: Scalar
        }
    }

}
