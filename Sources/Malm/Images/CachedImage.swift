//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

public protocol CachedImage: ImageWrapper, Identifiable {
    associatedtype Key: Hashable
    var key: Key { get }
    init(key: Key, image: Image)
}

public extension CachedImage {
    typealias ID = Key
    var id: ID { key }
}
