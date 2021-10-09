//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Malm
import Packa

struct ImageFromFrame: Hashable, File {
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
extension ImageFromFrame: Packable {
    var width: CGFloat { rect.width }
    var height: CGFloat { rect.height }
    
    typealias ID = String
    var id: ID { name  }
}

extension ImageFromFrame {
    var data: Data {
        let data = cgImage.png!
        return data
    }
}
