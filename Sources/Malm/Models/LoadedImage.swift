//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public final class LoadedImage: Hashable, Identifiable {
    public typealias ID = String
    
    /// globally unique id for this image
    public let id: ID
    public let width: Int
    public let height: Int
    
    public let image: CGImage
    
    public init(
        id: ID,
        width: Int,
        height: Int,
        image: CGImage
    ) {
        self.id = id
        self.width = width
        self.height = height
        self.image = image
    }
    
    public static func == (lhs: LoadedImage, rhs: LoadedImage) -> Bool {
        if lhs.id != rhs.id {
            assert(lhs.image != rhs.image)
            return false
        }
        assert(lhs.id == rhs.id)
        assert(lhs.height == rhs.height)
        assert(lhs.width == rhs.width)
        assert(lhs.image == rhs.image)
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
