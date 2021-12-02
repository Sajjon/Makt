//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation
import Common

public protocol Packable {
    var size: CGSize { get }
}

extension Packable {
    
    var width: CGFloat { size.width }
    var height: CGFloat { size.height }
    
    var maxSide: CGFloat { max(width, height) }
    
    var area: CGFloat {
        size.area
    }
}
