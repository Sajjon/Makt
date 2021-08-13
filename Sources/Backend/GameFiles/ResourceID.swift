//
//  ResourceID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

/// A type which identifies a resource clearly.
///
/// A resource might be of any of these kinds:
/// * Map
/// * Archive (.lod, .snd, .zip, .vid, .pac)
/// * Animation
/// * Sound (.82m, .wav)
/// * Image (.bmp, .png, .tga, ...)
/// * Video (.smk, ,mpg,...),
/// * Savegame
/// * Color Palette
/// * SOME OMITTED
///
public struct ResourceID: Equatable, Hashable, Identifiable {
    public let kind: Kind
    public let filePath: String
}

public extension ResourceID {
    typealias ID = String
    var id: ID { filePath }
}

public extension Identifiable where Self: RawRepresentable {
    typealias ID = RawValue
    var id: RawValue { rawValue }
}

public extension ResourceID {
    
    /**
     * Specifies the resource type.
     *
     * Supported file extensions:
     *
     * Text: .txt .json
     * Animation: .def
     * Mask: .msk .msg
     * Campaign: .h3c
     * Map: .h3m
     * Font: .fnt
     * Image: .bmp, .jpg, .pcx, .png, .tga
     * Sound: .wav .82m
     * Video: .smk, .bik .mjpg .mpg
     * Music: .mp3, .ogg
     * Archive: .lod, .snd, .vid .pac .zip
     * Palette: .pal
     * Savegame: .v*gm1
     */
    enum Kind: Equatable, Hashable, Identifiable {
        case text(TextResource)
        case animation(AnimationResource)
        case map(MapResource)
    }
}

public extension ResourceID.Kind {
    
    typealias ID = String
    var id: ID {
        switch self {
        case .text(let value): return value.id
        case .animation(let value): return value.id
        case .map(let value): return value.id
        }
    }
}

public extension ResourceID.Kind {
    enum TextResource: String, Equatable, Hashable, Identifiable {
        /// .txt file
        case txt
        
        /// .json file
        case json
    }
    enum AnimationResource: String, Equatable, Hashable, Identifiable {
        /// .def file
        case def
    }
    enum MapResource: String, Equatable, Hashable, Identifiable {
        /// .h3m file
        case map = "h3m"
    }
}

/*
 {
     enum Type
     {
         MASK,
         CAMPAIGN,
         BMP_FONT,
         TTF_FONT,
         IMAGE,
         VIDEO,
         SOUND,
         MUSIC,
         ARCHIVE_VID,
         ARCHIVE_ZIP,
         ARCHIVE_SND,
         ARCHIVE_LOD,
         PALETTE,
         CLIENT_SAVEGAME,
         SERVER_SAVEGAME,
         DIRECTORY,
         ERM,
         ERT,
         ERS,
         OTHER,
         UNDEFINED,
         LUA
     };
 }
*/
