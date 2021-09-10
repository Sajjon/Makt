//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension CaseIterable {
    static func random() -> Self {
        allCases.randomElement()!
    }
}
