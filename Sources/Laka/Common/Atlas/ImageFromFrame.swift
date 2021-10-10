//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Malm
import Packa

struct ImageFromFrame: Hashable, File, Packable {
    let name: String
    let cgImage: CGImage
    let fullSize: CGSize
    let rect: CGRect

    init(
        name: String,
        cgImage: CGImage,
        fullSize: CGSize,
        rect: CGRect
    ) {
        self.name = name
        self.cgImage = cgImage
        self.fullSize = fullSize
        self.rect = rect
    }
}

// MARK: Packable
extension ImageFromFrame {
    var size: CGSize { rect.size }
}

// MARK: File
extension ImageFromFrame {
    var data: Data {
        let data = cgImage.png!
        return data
    }
}
