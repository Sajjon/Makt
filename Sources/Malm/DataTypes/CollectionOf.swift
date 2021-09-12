//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation


public struct CollectionOf<Element>: Collection, CustomDebugStringConvertible, ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(values: elements)
    }
    public var debugDescription: String {
        values.map { String(describing: $0) }.joined(separator: ", ")
    }
    public let values: [Element]
    public init(values: [Element]) {
        self.values = values
    }
}

public extension CollectionOf {
    typealias Index = Array<Element>.Index
    var startIndex: Index { values.startIndex }
    var endIndex: Index { values.endIndex }
    func index(after index: Index) -> Index {
        values.index(after: index)
    }
    subscript(position: Index) -> Element { values[position] }
}

extension CollectionOf: Equatable where Element: Equatable {}
extension CollectionOf: Hashable where Element: Hashable {}

public extension CollectionOf where Element: CaseIterable, Element.AllCases == [Element] {
    static var allCases: Self { .init(values: .allCases) }
}
