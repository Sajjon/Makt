//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public enum Archive: Hashable, CaseIterable {
    
    public var kindName: String {
        switch self {
        case .lod: return "lod"
        case .sound: return "sound"
        case .video: return "video"
        }
    }
    
    case lod(LOD)
    case sound(Sound)
    case video(Video)
    
    public var fileName: String {
        switch self {
        case .lod(let value): return value.rawValue
        case .sound(let value): return value.rawValue
        case .video(let value): return value.rawValue
        }
    }
    
    public var isLODFile: Bool {
        guard case .lod = self else { return false }
        return true
    }
    
    public var isSNDFile: Bool {
        guard case .sound = self else { return false }
        return true
    }
    
    public var isVIDFile: Bool {
        guard case .video = self else { return false }
        return true
    }
    
    public static var allCases: [Self] {
        return LOD.allCases.map { Self.lod($0) } +
        Sound.allCases.map { Self.sound($0) } +
        Video.allCases.map { Self.video($0) }
    }
}

public extension Archive {
    enum LOD: String, Hashable, CaseIterable {
        case armageddonsBladeBitmapArchive = "H3ab_bmp.lod"
        case armageddonsBladeSpriteArchive = "H3ab_spr.lod"
        case restorationOfErathiaBitmapArchive = "H3bitmap.lod"
        
        /// H3sprite.lod
        /// Contains:
        /// * terrain tiles (46 frames each?)
        case restorationOfErathiaSpriteArchive = "H3sprite.lod"
    }
    
    enum Sound: String, Hashable, CaseIterable {
        case armageddonsBladeSoundFile = "H3ab_ahd.snd"
        case restorationOfErathiaSoundFile = "Heroes3.snd"
    }
    
    enum Video: String, Hashable, CaseIterable {
        case armageddonsBladeVideoFile = "H3ab_ahd.vid"
        case restorationOfErathiaVideoFile = "VIDEO.VID"
    }
}
