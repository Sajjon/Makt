//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension RawRepresentable where Self: CaseIterable, Self.AllCases == [Self], Self: Equatable {
    static func all<S>(but exclusion: S) -> [Self] where S: Sequence, S.Element == Self {
        allCases.all(but: exclusion)
    }
}
