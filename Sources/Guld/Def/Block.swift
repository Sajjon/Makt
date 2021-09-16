//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct Block: Hashable {
    public let identifier: Int
    public let frames: [DefinitionFile.Frame]
}
