//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

struct Fail: Swift.Error, CustomStringConvertible, Equatable {
    let description: String
}
