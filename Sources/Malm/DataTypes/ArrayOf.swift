//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Util

public protocol ElementsValidating {
    associatedtype Error: Swift.Error & Equatable
    associatedtype Element: Hashable
    static func validate(elements: [Element]) throws -> Bool
}

public struct ArrayOfValidatedElements<ElementsValidator: ElementsValidating>: Collection, CustomDebugStringConvertible {
    public typealias Error = ElementsValidator.Error
    public typealias Element = ElementsValidator.Element
    public let values: [Element]
  
    public init(checking values: [Element]) throws {
        guard try ElementsValidator.validate(elements: values) else {
            incorrectImplementation(reason: "Elements are invalid.")
        }
        self.values = values
    }
}

// MARK: CustomDebugStringConvertible
public extension ArrayOfValidatedElements {
    var debugDescription: String {
        values.map { String(describing: $0) }.joined(separator: ", ")
    }
}

// MARK: Collection
public extension ArrayOfValidatedElements {
    typealias Index = Array<Element>.Index
    var startIndex: Index { values.startIndex }
    var endIndex: Index { values.endIndex }
    func index(after index: Index) -> Index {
        values.index(after: index)
    }
    subscript(position: Index) -> Element { values[position] }
}

extension ArrayOfValidatedElements: Equatable where Element: Equatable {}
extension ArrayOfValidatedElements: Hashable where Element: Hashable {}

public extension ArrayOf where Element: CaseIterable, Element.AllCases == [Element] {
    static var allCases: Self { .init(values: .allCases) }
}

public struct AlwaysValid<Element: Hashable>: ElementsValidating {
    public typealias Error = Never
    public static func validate(elements _: [Element]) throws -> Bool { true }
}

public typealias ArrayOf<Element: Hashable> = ArrayOfValidatedElements<AlwaysValid<Element>>
public extension ArrayOf {
    init(values: [Element]) {
        try! self.init(checking: values)
    }
}
// MARK: ExpressibleByArrayLiteral
extension ArrayOf: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(values: elements)
    }
}

public protocol KeyPathGrouper: Grouping {
    static var keyPath: KeyPath<Element, Key> { get }
}
public extension KeyPathGrouper {
    static func keyForValue(_ element: Element) throws -> Key {
        element[keyPath: Self.keyPath]
    }
}

public protocol Grouping {
    associatedtype Element: Hashable
    associatedtype Key: Hashable
    static func keyForValue(_ element: Element) throws -> Key
}

public struct UniqueElements<Grouper: Grouping>: ElementsValidating {
    public typealias Element = Grouper.Element
    public typealias Key = Grouper.Key
    public enum Error: Swift.Error, Equatable {
        case duplicatedKeyFound(Key)
    }
    
    public static func validate(elements: [Element]) throws -> Bool {
        let duplicates = try Dictionary(
            grouping: elements,
            by: Grouper.keyForValue
        ).filter { $1.count > 1 }.keys
        
        if let duplicateKey = duplicates.first {
            throw Error.duplicatedKeyFound(duplicateKey)
        }
        return true
    }
}

public typealias ArrayOfUniqueByKeyPath<G: KeyPathGrouper> = ArrayOfValidatedElements<UniqueElements<G>>
