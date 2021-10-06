//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Malm

enum Exporter {
    case toMany((SimpleFile) throws -> [SimpleFile])
    case single((SimpleFile) throws -> SimpleFile)
    
    func export(_ simpleFile: SimpleFile) throws -> [SimpleFile] {
        switch self {
        case .single(let outputtingSingleFile):
            return try [outputtingSingleFile(simpleFile)]
        case .toMany(let outputtingManyFiles):
            return try outputtingManyFiles(simpleFile)
        }
    }
}

