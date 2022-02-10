//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-21.
//

import Foundation
import Common
import Malm

public final class H3CParser {
    private let reader: DataReader
    private let fileName: String
    public init(file: File) {
        self.reader = DataReader(data: file.data)
        self.fileName = file.name
    }
}

public extension H3CParser {
    func parse() throws -> Campaign {
        let header = try parseHeader()
        logger.debug("⚠️ Warning, not parsing campaign yet.")
//        return Campaign()
    implementMe()
    }
}

private extension H3CParser {
    func parseHeader() throws -> Campaign.Header {
        let format = try Campaign.Format(integer: reader.readUInt32())
        let regionIndex = try reader.readUInt8() - 1
        let name = try reader.readStringOfKnownMaxLength(500)! //Arbitraily chosen
        let description = try reader.readStringOfKnownMaxLength(10_000)! //Arbitraily chosen
        
        let difficultyChosenByPlayer: Difficulty = try format > .restorationOfErathia ? .init(integer: reader.readUInt8()) : .easy
        let lineNumberOfMusicID = try reader.readUInt8()
        
        return .init(
            fileName: fileName,
            format: format,
            regionIndex: regionIndex,
            name: name,
            description: description,
            difficultyChosenByPlayer: difficultyChosenByPlayer,
            lineNumberOfMusicID: lineNumberOfMusicID
        )
    }
    
}
