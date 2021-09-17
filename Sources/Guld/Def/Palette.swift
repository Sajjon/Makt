//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation

public struct Palette: Hashable {
    public let colors: [RGB]
}

public extension Palette {
    func toU32Array() -> [UInt32] {
        colors.enumerated().map { i, color in
            var data = Data()
            data.append(color.red)
            data.append(color.green)
            data.append(color.blue)
            data.append(255) // alpha
            data.reverse() // fix endianess
            return data.withUnsafeBytes { $0.load(as: UInt32.self) }
        }
    }
}
