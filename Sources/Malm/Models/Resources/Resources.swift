//
//  Resources.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Common

public struct Resources: Hashable, CustomDebugStringConvertible, Codable, ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Resource
    
    public init(arrayLiteral resources: ArrayLiteralElement...) {
        self.init(resources: resources)!
    }
    
    public let resources: [Resource.Kind: Resource]
    public init?(resources: [Resource]) {
        let nonEmpty = resources.filter { $0.quantity != 0 } // might be negative!
        let numberOfDifferentKinds = Set(nonEmpty.map({ $0.kind })).count
        guard numberOfDifferentKinds > 0 else {
            return nil
        }
        precondition(numberOfDifferentKinds == nonEmpty.count, "Expected to no find duplicates of kinds.")
        self.resources = .init(uniqueKeysWithValues: nonEmpty.map({ (key: $0.kind, valye: $0) }))
    }
}

public extension Resources {
    var debugDescription: String {
        resources.map { $0.value }.sorted(by: \.kind).map { $0.debugDescription }.joined(separator: "\n")
    }
}
