//
//  Map+Position+Extension.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//

import Foundation
@testable import HoMM3SwiftUI

extension Position {
    static func at(_ x: Int32, y: Int32) -> Self { .init(x: x, y: y, inUnderworld: false) }
}
