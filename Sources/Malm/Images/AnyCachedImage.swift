//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation

// MARK: AnyCachedImage
public struct AnyCachedImage: CacheableImage, Identifiable, Hashable {
    public let key: Key
    public let image: Image
    public init(key: Key, image: Image) {
        self.key = key
        self.image = image
    }
}

public extension AnyCachedImage {
    typealias Key = AnyHashable
    typealias ID = Key
    var id: ID { key }
    
    init<Concrete: CacheableImage>(_ concrete: Concrete) {
        self.init(key: AnyHashable(concrete.key), image: concrete.image)
    }
}
