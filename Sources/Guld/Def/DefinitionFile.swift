//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct DefinitionFile {
    public typealias Scalar = Int
    public let width: Scalar
    public let height: Scalar
    public let palette: [RGB]
    public let blocks: [Block]
}
