//
//  Difficulty.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public enum Difficulty: UInt8, Hashable, CaseIterable, Codable {
    case easy, normal, hard, expert, impossible
}
