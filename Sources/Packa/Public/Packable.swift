//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation
import Util

public protocol Packable: Identifiable {
    var width: CGFloat { get }
    var height: CGFloat { get }
}

extension Packable {
    
    var size: CGSize { .init(width: width, height: height) }
    var maxSide: CGFloat { max(width, height) }
    
    var area: CGFloat {
        size.area
    }
}
