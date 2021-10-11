//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation

public struct PackedCanvas<Content: Packable> {
    public let packed: [Packed<Content>]
    public let canvasSize: CGSize
}
