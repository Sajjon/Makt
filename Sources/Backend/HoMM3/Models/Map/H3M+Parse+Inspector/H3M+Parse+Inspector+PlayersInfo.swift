//
//  H3M+Parse+Inspector+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-29.
//

import Foundation

public extension Map.Loader.Parser.Inspector {
        
        final class PlayersInfoInspector {
            public typealias OnParseROEBasic = (Map.InformationAboutPlayers.ROE.Basic, PlayerColor) -> Void
            public typealias OnParseROEExtra = (Map.InformationAboutPlayers.ROE.Extra, PlayerColor) -> Void
            private let onParseROEBasic: OnParseROEBasic?
            private let onParseROEExtra: OnParseROEExtra?
            
            public typealias OnParseABBasic = (Map.InformationAboutPlayers.AB.Basic, PlayerColor) -> Void
            public typealias OnParseABSODExtra = (Map.InformationAboutPlayers.ExtraABSOD, PlayerColor) -> Void
            private let onParseABBasic: OnParseABBasic?
            private let onParseABSODExtra: OnParseABSODExtra?
            
            public init(
                onParseROEBasic: OnParseROEBasic? = nil,
                onParseROEExtra: OnParseROEExtra? = nil,
                
                onParseABBasic: OnParseABBasic? = nil,
                onParseABSODExtra: OnParseABSODExtra? = nil
            ) {
                self.onParseROEBasic = onParseROEBasic
                self.onParseROEExtra = onParseROEExtra
                
                self.onParseABBasic = onParseABBasic
                self.onParseABSODExtra = onParseABSODExtra
            }
            
            func didParsePlayerInfoROEBasic(_ basic: Map.InformationAboutPlayers.ROE.Basic, color: PlayerColor) {
                onParseROEBasic?(basic, color)
            }
            
            func didParsePlayerInfoROEExtra(_ extra: Map.InformationAboutPlayers.ROE.Extra, color: PlayerColor) {
                onParseROEExtra?(extra, color)
            }
            
            
            func didParsePlayerInfoABBasic(_ basic: Map.InformationAboutPlayers.AB.Basic, color: PlayerColor) {
                onParseABBasic?(basic, color)
            }
            
            func didParsePlayerInfoABSODExtra(_ extra: Map.InformationAboutPlayers.ExtraABSOD, color: PlayerColor) {
                onParseABSODExtra?(extra, color)
            }
        }
        
}
