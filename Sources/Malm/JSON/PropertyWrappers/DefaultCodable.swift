// MIT License
//
// Copyright (c) 2019 Mark Sands
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// FROM: https://github.com/marksands/BetterCodable/blob/master/Sources/BetterCodable/DefaultCodable.swift

import Foundation

/// Provides a default value for missing `Decodable` data.
///
/// `DefaultCodableStrategy` provides a generic strategy type that the `DefaultCodable` property wrapper can use to provide
/// a reasonable default value for missing Decodable data.
public protocol DefaultCodableStrategy {
    associatedtype DefaultValue: Decodable
    
    /// The fallback value used when decoding fails
    static var defaultValue: DefaultValue { get }
    
    static var skipEncodingIfValueEquals: DefaultValue? { get }
}

public extension DefaultCodableStrategy {
    var skipEncodingIfValueEquals: DefaultValue? { Self.skipEncodingIfValueEquals }
//    static var skipEncodingIfValueEquals: DefaultValue? { nil }
}

/// Decodes values with a reasonable default value
///
/// `@Defaultable` attempts to decode a value and falls back to a default type provided by the generic
/// `DefaultCodableStrategy`.
@propertyWrapper
public struct DefaultCodable<Default: DefaultCodableStrategy> {
    public var wrappedValue: Default.DefaultValue
    
    public init(wrappedValue: Default.DefaultValue) {
        self.wrappedValue = wrappedValue
    }
}

extension DefaultCodable: Decodable where Default.DefaultValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(Default.DefaultValue.self)) ?? Default.defaultValue
    }
}

extension DefaultCodable: Encodable where Default.DefaultValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultCodable: Equatable where Default.DefaultValue: Equatable { }
extension DefaultCodable: Hashable where Default.DefaultValue: Hashable { }

// MARK: - KeyedDecodingContainer
public protocol BoolCodableStrategy: DefaultCodableStrategy where DefaultValue == Bool {}

public extension KeyedEncodingContainer {
    mutating func encode<P: BoolCodableStrategy>(_ value: DefaultCodable<P>, forKey key: Key) throws {
        if let valueToAvoid = P.skipEncodingIfValueEquals {
            guard
                value.wrappedValue != valueToAvoid
            else {
                return
            }
        }
       
        try self.encode(value.wrappedValue, forKey: key)
    }
}

public extension KeyedDecodingContainer {

    /// Default implementation of decoding a DefaultCodable
    ///
    /// Decodes successfully if key is available if not fallsback to the default value provided.
    func decode<P>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        if let value = try decodeIfPresent(DefaultCodable<P>.self, forKey: key) {
            return value
        } else {
            return DefaultCodable(wrappedValue: P.defaultValue)
        }
    }

    /// Default implementation of decoding a `DefaultCodable` where its strategy is a `BoolCodableStrategy`.
    ///
    /// Tries to initially Decode a `Bool` if available, otherwise tries to decode it as an `Int` or `String`
    /// when there is a `typeMismatch` decoding error. This preserves the actual value of the `Bool` in which
    /// the data provider might be sending the value as different types. If everything fails defaults to
    /// the `defaultValue` provided by the strategy.
    func decode<P: BoolCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Bool.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                case .typeMismatch = decodingError else {
                    return DefaultCodable(wrappedValue: P.defaultValue)
            }
            if let intValue = try? decodeIfPresent(Int.self, forKey: key),
                let bool = Bool(exactly: NSNumber(value: intValue)) {
                return DefaultCodable(wrappedValue: bool)
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key),
                let bool = Bool(stringValue) {
                return DefaultCodable(wrappedValue: bool)
            } else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
        }
    }
}
