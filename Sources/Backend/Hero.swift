//
//  Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public struct Hero: Equatable, Identifiable {
    public let id: ID
}
public extension Hero {
    struct ID: Hashable {
        public let id: Int
    }
    
    struct Portrait: Equatable, Identifiable {
        public let id: ID
    }
}
public extension Hero.Portrait {
    struct ID: Hashable {
        public let id: Int
    }
}

public extension Hero {
    struct Custom: Equatable {
        let id: Hero.ID
        let portraitId: Hero.Portrait.ID
        let name: String
    }
    
    struct Seed: Equatable {
        let id: Hero.ID
        let name: String
    }
    
}
