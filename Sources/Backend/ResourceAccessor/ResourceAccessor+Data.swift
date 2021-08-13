//
//  ResourceAccessor+Directory+Data.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension ResourceAccessor {
    enum Data: ResourceKind {}
}

public extension ResourceAccessor.Data {
    enum Content: String, FileNameConvertible, Equatable, Hashable, CaseIterable {
       
        case H3ab_ahd__dot__snd
        case H3ab_ahd__dot__vid
        case H3ab_bmp__dot__lod
        case H3ab_spr__dot__lod
        case H3bitmap__dot__lod
        case H3sprite__dot__lod
        case Heroes3__dot__snd
        case VIDEO__dot__VID
        
    }
}

public extension ResourceAccessor.Data.Content {
    var fileName: String {
        rawValue.replacingOccurrences(of: "__dot__", with: ".")
    }
}
