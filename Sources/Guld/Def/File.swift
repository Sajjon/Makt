//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct File: Hashable {
    public let size: Int
    public typealias Scalar = Int
    public let fullWidth: Scalar
    public let fullHeight: Scalar
    public let width: Scalar
    public let height: Scalar
    public let offset: Offset
    public let pixels: [Int]
    
    public struct Offset: Hashable {
        public let left: Scalar
        public let top: Scalar
    }
}
