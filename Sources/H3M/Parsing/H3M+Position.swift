//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Malm

extension H3M {
    func parsePosition() throws -> Position {
        try .init(
            x: .init(reader.readUInt8()),
            y: .init(reader.readUInt8()),
            inUnderworld: reader.readBool()
        )
    }
}
