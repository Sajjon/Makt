//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

import Util
import Malm


public final class LodFile: ArchiveProtocol {
    public let archiveKind: Archive
    public let entries: [FileEntry]
    
    public init(
        archiveKind: Archive,
        entries: [FileEntry]
    ) {
//        print("🗂 Archive named: '\(archiveKind.fileName)' contains these entries:\n\(entries.map({$0.fileName}).joined(separator: "\n"))\n")
        self.archiveKind = archiveKind
        self.entries = entries
    }
}

public extension LodFile {
    var archiveName: String {
        archiveKind.fileName
    }
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
        
        case pcx(() -> PCXImage)
        case def((DefParser.Inspector?) -> DefinitionFile)
        case text(() -> String)
        case font(() -> BitmapFont)
        case mask(() -> Mask)
        case campaign(() -> Campaign)
        case palette(() -> Palette)
        
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
            static let ignored: [RawValue] = ["ifr", "xmi"]

            
            case palette = "pal"
            
//            /// E*X*tended *M*ultiple *I*nstrumental digital interface is a MIDI-like format.
//            /// http://www.vgmpf.com/Wiki/index.php?title=XMI#:~:text=Extended%20Multiple%20Instrument%20Digital%20Interface%20(XMI)%20is%20a%20MIDI%2D,developed%20and%20released%20in%201991.
//            ///
//            case xmi = "xmi"
            
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
