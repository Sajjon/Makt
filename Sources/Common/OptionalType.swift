//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation


public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}
extension Optional: OptionalType {
    public var wrapped: Wrapped? {
        switch self {
        case .none: return nil
        case .some(let wrapped): return wrapped
        }
        
    }
}

public extension Sequence where Element: OptionalType {
    func filterNils() -> [Element.Wrapped] {
        compactMap({ $0.wrapped })
    }
}
