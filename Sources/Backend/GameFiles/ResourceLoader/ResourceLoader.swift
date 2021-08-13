//
//  ResourceLoader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

/// A type which knows the files containing in the archive or system and how to load them.
///
/// VCMI: class: "ISimpleResourceLoader" and namespace: "CResourceHandler"
public final class ResourceLoader {
    private let config: ResourceAccessor
    public init(config: ResourceAccessor) {
        self.config = config
    }
}

public extension ResourceLoader {
//    func load
}
