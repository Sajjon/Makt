//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Array where Element: CaseIterable, Element.AllCases == [Element] {
    static var allCases: [Element] { Element.allCases }
}
