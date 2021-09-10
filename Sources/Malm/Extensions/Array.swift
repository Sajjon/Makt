//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Array where Element: Equatable {
    func all<S>(but exclusion: S) -> [Element] where S: Sequence, S.Element == Self.Element {
        filter({ element in !exclusion.contains(where: { $0 == element }) })
    }
    
    func all<S, Member>(
        but exclusion: S,
        map: (Element) -> Member
    ) -> [Element] where S: Sequence, S.Element == Member, Member: Equatable {
        filter({ element in
            let member = map(element)
            return !exclusion.contains(where: { $0 == member })
        })
    }
    
    func all<S, Member>(
        member keyPath: KeyPath<Element, Member>,
        but exclusion: S
    ) -> [Element] where S: Sequence, S.Element == Member, Member: Equatable {
        all(but: exclusion) { $0[keyPath: keyPath] }
    }
}



internal extension Array {
    func chunked(into size: Int, assertSameLength: Bool = true) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            let array = Array(self[$0 ..< Swift.min($0 + size, count)])
            if assertSameLength {
                assert(array.count == size)
            }
            return array
        }
    }
}
