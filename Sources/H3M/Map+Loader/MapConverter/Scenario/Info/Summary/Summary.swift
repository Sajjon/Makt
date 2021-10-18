//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Info {
    
    /// Summary of this playable scenario
    struct Summary: Model {
        public let name: String
        public let size: Size
    }
}
