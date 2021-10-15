//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-15.
//

import Foundation

public struct DefaultTrueOnlyEncodeIfFalseStrategy: BoolCodableStrategy {
    public static var defaultValue: Bool { true }
    public static var skipEncodingIfValueEquals: Bool? { true }
}

/// **Decodes** Bools defaulting to `true` if applicable, only **encodes** if
/// value is `false`.
public typealias SkipEncodingIfTrue = DefaultCodable<DefaultTrueOnlyEncodeIfFalseStrategy>
