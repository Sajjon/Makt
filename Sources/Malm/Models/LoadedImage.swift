//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public final class LoadedImage: Hashable, Identifiable {
    public enum ID: Hashable, CustomDebugStringConvertible {
        public struct Terrain: Hashable, CustomDebugStringConvertible {
            public let frameName: String
            public let mirroring: Mirroring
            public init(
                frameName: String,
                mirroring: Mirroring
            ) {
                self.frameName = frameName
//                self.viewID = viewID
                self.mirroring = mirroring
            }
            
            public var debugDescription: String {
                "frameName: \(frameName), mirroring: \(mirroring)"
            }
            
        }
        case terrain(Terrain)
        public var debugDescription: String {
            switch self {
            case .terrain(let terrain): return String(describing: terrain)
            }
        }
    }
    
    /// globally unique id for this image
    public let id: ID
    public let width: Int
    public let height: Int
    public let mirroring: Mirroring
    
    public let image: CGImage
    
    public init(
        id: ID,
        width: Int,
        height: Int,
        mirroring: Mirroring,
        image: CGImage
    ) {
        self.id = id
        self.width = width
        self.height = height
        self.image = image
        self.mirroring = mirroring
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
        assert(lhs.mirroring == rhs.mirroring)
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
