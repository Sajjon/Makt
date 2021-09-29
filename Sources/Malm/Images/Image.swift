//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

public final class Image: CGImageWrapper, Hashable, CustomDebugStringConvertible {
    public let cgImage: CGImage
    public let hint: String
    public let mirroring: Mirroring
    
    public init(
        cgImage: CGImage,
        mirroring: Mirroring,
        hint: String
    ) {
        self.cgImage = cgImage
        self.hint = hint
        self.mirroring = mirroring
    }
}

// MARK: Equatable
public extension Image {
    static func == (lhs: Image, rhs: Image) -> Bool {
        guard lhs.cgImage === rhs.cgImage else {
            assert(lhs.cgImage != rhs.cgImage)
            return false
        }
        assert(lhs.height == rhs.height)
        assert(lhs.width == rhs.width)
        assert(lhs.hint == rhs.hint)
        let sameMirroring = lhs.mirroring == rhs.mirroring
        return sameMirroring
    }
}

// MARK: Hashable
public extension Image {
    func hash(into hasher: inout Hasher) {
        hasher.combine(cgImage)
        hasher.combine(mirroring)
    }
}


// MARK: CustomDebugStringConvertible
public extension Image {
    var debugDescription: String {
        """
        hint about content: \(hint)
        mirroring: \(mirroring)
        cgImage: \(String(describing: cgImage))
        image memory address: \(String.pointer(cgImage))
        """
    }
}

extension String {
    static func pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "<DEALLOCATED>" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}
