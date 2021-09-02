//
//  Resources.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

public struct Resources: Hashable {
    public let resources: [Resource.Kind: Resource]
    public init?(resources: [Resource]) {
        let nonEmpty = resources.filter { $0.amount != 0 } // might be negative!
        let numberOfDifferentKinds = Set(nonEmpty.map({ $0.kind })).count
        guard numberOfDifferentKinds > 0 else {
            return nil
        }
        precondition(numberOfDifferentKinds == nonEmpty.count, "Expected to no find duplicates of kinds.")
        self.resources = .init(uniqueKeysWithValues: nonEmpty.map({ (key: $0.kind, valye: $0) }))
    }
}
