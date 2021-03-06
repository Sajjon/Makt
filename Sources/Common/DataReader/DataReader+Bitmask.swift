//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension DataReader {
    func readBitArray(byteCount: Int) throws -> BitArray {
        try BitArray(data: read(byteCount: byteCount))
    }
}

