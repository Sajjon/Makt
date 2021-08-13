//
//  ResourceAccessor+ResourceKind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public protocol ResourceKind: Hashable where Content: RawRepresentable, Content.RawValue == String {
    associatedtype Content: FileNameConvertible & Hashable
    static var name: String { get }
    static var requiredDirectoryContents: [Content] { get }
}

public extension ResourceKind {
    static var name: String { .init(describing: self) }
}

// MARK: ResourceKind + CaseIterable
public extension ResourceKind where Content: CaseIterable, Content.AllCases == [Content] {
    static var requiredDirectoryContents: [Content] { Content.allCases }
}

// MARK: FileNameConvertible
public protocol FileNameConvertible {
    var fileName: String { get }
}

// MARK: FileNameConvertible + RawRepresentable
public extension FileNameConvertible where Self: RawRepresentable, Self.RawValue == String {
    var fileName: String { rawValue }
}

