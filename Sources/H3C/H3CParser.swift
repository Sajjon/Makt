//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-21.
//

import Foundation
import Util
import Malm

public final class H3CParser {
    private let reader: DataReader
    public init(data: Data) {
        self.reader = DataReader(data: data)
    }
}

public extension H3CParser {
    func parse() throws -> Campaign {
        fatalError()
    }
}
