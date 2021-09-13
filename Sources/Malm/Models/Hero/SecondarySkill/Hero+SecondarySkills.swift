//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import Foundation

public extension Hero.SecondarySkill {
    struct Grouper: KeyPathGrouper {
        public typealias Element = Hero.SecondarySkill
        public typealias Key = Hero.SecondarySkill.Kind
        public static let keyPath: KeyPath<Element, Key> = \.kind
    }
}

public extension Hero {
    typealias SecondarySkills = ArrayOfUniqueByKeyPath<SecondarySkill.Grouper>
}
