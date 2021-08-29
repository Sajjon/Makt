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
            private let onParseROEBasic: OnParseROEBasic?
            public init(
                onParseROEBasic: OnParseROEBasic? = nil
            ) {
                self.onParseROEBasic = onParseROEBasic
            }
            
            func didParsePlayerInfoROEBasic(_ basic: Map.InformationAboutPlayers.ROE.Basic, color: PlayerColor) {
                onParseROEBasic?(basic, color)
            }
        }
        
}
