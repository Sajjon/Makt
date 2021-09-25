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
    
    struct FileEntry: ArchiveFileEntry, Hashable {
        public let parentArchiveName: String
        public let fileName: String
        public let content: Content
        public let byteCount: Int
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(parentArchiveName)
            hasher.combine(content.kind)
            hasher.combine(fileName)
        }
    }
}

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
        case xmi(AnyPublisher<Data, Never>)
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
            case .xmi: return .xmi
            }
        }
        
        public enum Kind: String, Hashable {
            static let ignored: [RawValue] = ["ifr"]

            
            case palette = "pal"
            
            /// E*X*tended *M*ultiple *I*nstrumental digital interface is a MIDI-like format.
            /// http://www.vgmpf.com/Wiki/index.php?title=XMI#:~:text=Extended%20Multiple%20Instrument%20Digital%20Interface%20(XMI)%20is%20a%20MIDI%2D,developed%20and%20released%20in%201991.
            ///
            case xmi = "xmi"
            
            case campaign = "h3c"
            case font = "fnt"
            case text = "txt"
            
            /// .msk is a passability matrix
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
        guard let fileExtension = fileName.fileExtension else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Get file extension of entry.")
        }
    
        let fileExtensionIgnoreCase = fileExtension.lowercased()
        
        guard let kind = Self(rawValue: String(fileExtensionIgnoreCase)) else {
            return nil
        }
        self = kind
    }
}

extension String {
    var fileExtension: String? {
        guard let fileExt = split(separator: ".").last else {
            return nil
        }

        return String(fileExt)
    }

}
