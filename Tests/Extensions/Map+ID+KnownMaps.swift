//
//  Map+ID+KnownMaps.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-15.
//

import HoMM3SwiftUI

extension Map.ID {
    static let tutorial: Self = "Tutorial.tut"
    
    static func h3m(_ name: String) -> Self {
        .init(fileName: name.appending("." + Self.fileExtension))
    }
    

    static let titansWinter: Self = .h3m("Titans Winter")
    static let unholyQuest: Self = .h3m("Unholy Quest")
    static let theMandateOfHeaven: Self = .h3m("The Mandate of Heaven")
    static let rebellion: Self = .h3m("Rebellion")
    
    static let raceforArdintinny: Self = .h3m("Race for Ardintinny")
    
    static let vikingWeShallGo: Self = .h3m("A Viking We Shall Go")
    static let noahsArk: Self = .h3m("Noahs Ark")
    static let overthrowThyNeighbour: Self = .h3m("Overthrow Thy Neighbors")
    static let mythAndLegend: Self = .h3m("Myth and Legend")

    static let taleOfTwoLandsAllies: Self = .h3m("Tale of two lands (Allies)")
    static let thousandIslandsAllies: Self = .h3m("Thousand Islands (allies)")
    
    static let reclamationAllies: Self = .h3m("Reclamation Allied")
    static let peacefulEndingAllies: Self = .h3m("Peaceful Ending - Allied")
    
    

}
