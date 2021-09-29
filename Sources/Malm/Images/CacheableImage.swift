//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation

public protocol CacheableImage: ImageWrapper, Identifiable {
    associatedtype Key: Hashable
    var key: Key { get }
    init(key: Key, image: Image)
}

public extension CacheableImage {
    typealias ID = Key
    var id: ID { key }
}
