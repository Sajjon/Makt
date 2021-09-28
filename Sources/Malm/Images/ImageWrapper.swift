//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

public protocol ImageWrapper: CGImageWrapper {
    var image: Image { get }
}

public extension ImageWrapper {
    var cgImage: CGImage { image.cgImage }
    var hint: String { image.hint }
}
