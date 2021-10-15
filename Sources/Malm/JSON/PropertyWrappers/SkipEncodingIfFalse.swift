//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-15.
//

import Foundation


public struct DefaultFalseOnlyEncodeIfTrueStrategy: BoolCodableStrategy {
    public static var defaultValue: Bool { false }
    public static var skipEncodingIfValueEquals: Bool? { false }
}

/// **Decodes** Bools defaulting to `false` if applicable, only **encodes** if
/// value is `true`.
public typealias SkipEncodingIfFalse = DefaultCodable<DefaultFalseOnlyEncodeIfTrueStrategy>
