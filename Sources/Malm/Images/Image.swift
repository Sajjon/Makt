//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

public final class Image: CGImageWrapper, Equatable, CustomDebugStringConvertible {
    public let cgImage: CGImage
    public let hint: String
    
    public init(
        cgImage: CGImage,
        hint: String
    ) {
        self.cgImage = cgImage
        self.hint = hint
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
        return true
    }
}


// MARK: CustomDebugStringConvertible
public extension Image {
    var debugDescription: String {
        """
        hint about content: \(hint)
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
