//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

public protocol CGImageWrapper {
    var cgImage: CGImage { get }
    var hint: String { get }
}

public extension CGImageWrapper {
    var width: Int {
        cgImage.width
    }
    
    var height: Int {
        cgImage.height
    }
}
