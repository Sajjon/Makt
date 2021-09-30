//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation

public protocol CacheableImage: ImageWrapper, Identifiable where ID == Key {
    associatedtype Key
    var key: Key { get }
    init(key: Key, image: Image)
}

public extension CacheableImage {
    var id: ID { key }
}
