//
//  Map+Object+CreatureBank.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation


public extension Map.Object {
    enum CreatureBank: UInt8, Equatable, CaseIterable {
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
