//
//  Map+Object+CreatureBank.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public extension Map.Object {
    enum CreatureBank: Equatable {}
}


public extension Map.Object.CreatureBank {
    enum ID: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        case cyclopsStockpile = 0,
             dwarvenTreasury,
             griffinConservatory,
             impCache,
             medusaStores,
             nagaBank,
             dragonFlyHive = 6
        
        #if WOG
        case huntingLodge = 11,
             snowCoveredGrotto,
             
             
             /// (Emissaries of War)
             palaceOfMartialSpirit,
             /// (Emissaries of Peace)
             citadelOfPacification,
             
             /// (Emissaries of Mana)
             monasteryOfMagicians,
             /// (Emissaries of Lore)
             libraryOfLegends,
             
             transylvanianTavern,
             homeOfTheBat,
             lostBottle,
             grotto
        #endif // WOG
    }
}

public extension Map.Object.CreatureBank.ID {
    var debugDescription: String {
        switch self {
        case .cyclopsStockpile: return "cyclopsStockpile"
        case .dwarvenTreasury: return "dwarvenTreasury"
        case .griffinConservatory: return "griffinConservatory"
        case .impCache: return "impCache"
        case .medusaStores: return "medusaStores"
        case .nagaBank: return "nagaBank"
        case .dragonFlyHive: return "dragonFlyHive"
            
            
            
        }
        
        
        
    }
}
