//
//  H3M+Parse+Inspector+BasicInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-29.
//

import Foundation
import Malm

public extension Map.Loader.Parser.Inspector {
    
    final class BasicInfoInspector {
        
        private let onParseFormat: OnParseFormat?
        private let onParseName: OnParseName?
        private let onParseDescription: OnParseDescription?
        private let onParseDifficulty: OnParseDifficulty?
        private let onParseSize: OnParseSize?
        private let onFinishedParsingBasicInfo: OnFinishedParsingBasicInfo?
        
        public init(
            onParseFormat: OnParseFormat? = nil,
            onParseName: OnParseName? = nil,
            onParseDescription: OnParseDescription? = nil,
            onParseDifficulty: OnParseDifficulty? = nil,
            onParseSize: OnParseSize? = nil,
            onFinishedParsingBasicInfo: OnFinishedParsingBasicInfo? = nil
        ) {
            self.onParseFormat = onParseFormat
            self.onParseName = onParseName
            self.onParseDescription = onParseDescription
            self.onParseDifficulty = onParseDifficulty
            self.onParseSize = onParseSize
            self.onFinishedParsingBasicInfo = onFinishedParsingBasicInfo
        }
    }
}

public extension Map.Loader.Parser.Inspector.BasicInfoInspector {
    typealias OnParseFormat = (Map.Format) -> Void
    typealias OnParseName = (String) -> Void
    typealias OnParseDescription = (String) -> Void
    typealias OnParseDifficulty = (Difficulty) -> Void
    typealias OnParseSize = (Size) -> Void
    typealias OnFinishedParsingBasicInfo = (Map.BasicInformation) -> Void
    
    func didParseFormat(_ value: (Map.Format)) {
        onParseFormat?(value)
    }
    
    func didParseName(_ value: String) {
        onParseName?(value)
    }
    
    func didParseDescription(_ value: String) {
        onParseDescription?(value)
    }
    
    func didParseDifficulty(_ value: Difficulty) {
        onParseDifficulty?(value)
    }
    
    func didParseSize(_ value: Size) {
        onParseSize?(value)
    }
    
    func didFinishedParsingBasicInfo(_ value: Map.BasicInformation) {
        onFinishedParsingBasicInfo?(value)
    }
}
