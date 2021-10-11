//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation

struct FramesInAtlas: Codable {
    let meta: Meta
    private var frames: [Frame]
    
    init(meta: Meta) {
        self.meta = meta
        self.frames = []
    }
}

extension FramesInAtlas {
    mutating func add(frame: Frame) {
        frames.append(frame)
    }
}

extension FramesInAtlas {
    
    // MARK: Meta
    struct Meta: Codable {
        let image: String
        let format: String
        let size: Size
        
        init(
            atlasName: String,
            colorSpace: CGColorSpace,
            size cgSize: CGSize
        ) {
            self.image = atlasName
            self.format = colorSpace.name! as String
            self.size = .init(cgSize: cgSize)
        }
    }
    
    // MARK: Frame
    struct Frame: Codable {
        let name: String
        let sourceRect: Rect
        let fullSize: Size
        let rectInAtlas: Rect
        
        init(name: String, sourceRect: CGRect, fullSize: Size, rectInAtlas: CGRect) {
            self.name = name
            self.sourceRect = .init(cgRect: sourceRect)
            self.fullSize = fullSize
            self.rectInAtlas = .init(cgRect: rectInAtlas)
        }
    }
}

extension FramesInAtlas {
    
    // MARK: Size
    struct Size: Codable {
        let width: Int
        let height: Int
        init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
        init(cgSize: CGSize) {
            self.init(width: .init(cgSize.width), height: .init(cgSize.height))
        }
    }
    
    // MARK: Origin
    struct Origin: Codable {
        let x: Int
        let y: Int
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        init(cgPoint: CGPoint) {
            self.init(x: .init(cgPoint.x), y: .init(cgPoint.y))
        }
    }
    
    // MARK: Rect
    struct Rect: Codable {
        let origin: Origin
        let size: Size
        init(origin: Origin, size: Size) {
            self.origin = origin
            self.size = size
        }
        init(cgRect: CGRect) {
            self.init(origin: .init(cgPoint: cgRect.origin), size: .init(cgSize: cgRect.size))
        }
    }
}
