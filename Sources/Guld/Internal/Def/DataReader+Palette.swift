//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Common

internal extension DataReader {
    func readPalette() throws -> Palette {
        try .init(colors: 256.nTimes {
            try .init(
                red: readUInt8(),
                green: readUInt8(),
                blue: readUInt8()
            )
        })
    }
}
