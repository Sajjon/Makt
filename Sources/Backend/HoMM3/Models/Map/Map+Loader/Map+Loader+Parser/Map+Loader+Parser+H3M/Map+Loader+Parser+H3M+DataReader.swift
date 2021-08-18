//
//  Map+Loader+Parser+H3M+DataReader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

extension DataReader {
    func readHeroID<E>(elseThrow error: (Hero.ID.RawValue) -> E) throws -> Hero.ID? where E: Swift.Error {
        let heroIDRaw = try readUInt8()
        guard heroIDRaw != 0xff else { return nil }
        guard let heroID = Hero.ID(rawValue: heroIDRaw) else {
            throw error(heroIDRaw)
        }
        return heroID
    }
}
