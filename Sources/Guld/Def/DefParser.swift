//
//  File 2.swift
//  File 2
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Util

public final class DefParser {
    internal let reader: DataReader
    public init(data: Data) {
        self.reader = DataReader(data: data)
    }
}

public extension DefParser {
    func parse() throws -> DefinitionFile {
        let kind = try reader.readUInt32()
        fatalError()
    }
}
