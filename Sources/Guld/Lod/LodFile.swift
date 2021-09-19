//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Combine

import Util
import Malm


public struct LodFile: Hashable {
    public let lodFileName: String
    public let entries: [FileEntry]
}

public extension LodFile {
    struct CompressedFileEntryMetaData: Hashable {
        public let name: String
        public let fileOffset: Int
        public let size: Int
        public let compressedSize: Int
    }
    
    struct FileEntry: Hashable {
        public let name: String
//        public let kind: Content.Kind
        public let content: Content
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(content.kind)
            hasher.combine(name)
        }
    }
}

public struct Campaign: Hashable {}
public typealias Mask = Map.Object.Attributes.Pathfinding.Passability

public extension LodFile.FileEntry {
    
    enum Content: Equatable {
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.kind == rhs.kind
        }
        
        
        case pcx(AnyPublisher<PCXImage, Never>)
        case def(AnyPublisher<DefinitionFile, Never>)
        case text(AnyPublisher<String, Never>)
        case font(AnyPublisher<CGFont, Never>)
        case mask(AnyPublisher<Mask, Never>)
        case campaign(AnyPublisher<Campaign, Never>)
        case palette(AnyPublisher<Palette, Never>)
        
        public var kind: Kind {
            switch self {
            case .campaign: return .campaign
            case .def: return .def
            case .font: return .font
            case .palette: return .palette
            case .text: return .text
            case .pcx: return .pcx
            case .mask: return .mask
            }
        }
        
        public enum Kind: String, Hashable {
            
            // What is this?
            case ifr = "ifr"
            
            case palette = "pal"
            
            /// what is this?
            case xmi = "xmi"
            
            case campaign = "h3c"
            case font = "fnt"
            case text = "txt"
            
            /// .msk
            case mask = "msk"
            
            /// .pcx
            case pcx
            
            /// .def
            case def
        }
    }
    
}

internal extension LodFile.FileEntry.Content.Kind {
    init?(fileName: String) {
        guard let fileExtension = fileName.split(separator: ".").last else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Get file extension of entry.")
        }
        let fileExtensionIgnoreCase = fileExtension.lowercased()
        
        guard let kind = Self(rawValue: String(fileExtensionIgnoreCase)) else {
            return nil
        }
        self = kind
    }
}
