//
//  Map+Object+KeyColor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public extension Map.Object {
    
    typealias BorderGuardTentType = KeyColor
    typealias KeymastersTentType = KeyColor
    
    enum KeyColor: UInt8, Equatable, CaseIterable {
       case lightBlue
       case playerFour
       case playerOne
       case darkBlue
       case brown
       case playerSix
       case white
       case black
    }
}
