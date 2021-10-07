//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Foundation
import Malm

struct ImageFromFrame: File {
    let name: String
    let cgImage: CGImage
    let fullSize: CGSize
    let rect: CGRect
}

extension ImageFromFrame {
    var data: Data {
        let data = cgImage.png!
        return data
    }
}
