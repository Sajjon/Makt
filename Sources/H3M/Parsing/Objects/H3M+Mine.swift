//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseMine(kind: Map.Mine.Kind? = nil) throws -> Map.Mine {
        let mine = try Map.Mine(kind: kind, owner: .init(rawValue: reader.readUInt8()))
        try reader.skip(byteCount: 3)
        return mine
    }
}
