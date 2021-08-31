//
//  H3M+Parse+Inspector+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-29.
//

import Foundation

public extension Map.Loader.Parser.Inspector {
    
    final class PlayersInfoInspector {
        
        private let onParseIsPlayableByHuman  : OnParseIsPlayableByHuman?
        private let onParseIsPlayableByAI: OnParseIsPlayableByAI?
        private let onParseAITactic: OnParseAITactic?
        private let onParsePlayableFactions: OnParsePlayableFactions?
        private let onParseHasMainTown: OnParseHasMainTown?
        private let onParseMainTown: OnParseMainTown?
        
        public init(
            onParseIsPlayableByHuman  : OnParseIsPlayableByHuman? = nil,
            onParseIsPlayableByAI: OnParseIsPlayableByAI? = nil,
            onParseAITactic: OnParseAITactic? = nil,
            onParsePlayableFactions: OnParsePlayableFactions? = nil,
            onParseHasMainTown: OnParseHasMainTown? = nil,
            onParseMainTown: OnParseMainTown? = nil
        ) {
            self.onParseIsPlayableByHuman = onParseIsPlayableByHuman
            self.onParseIsPlayableByAI = onParseIsPlayableByAI
            self.onParseAITactic = onParseAITactic
            self.onParsePlayableFactions = onParsePlayableFactions
            self.onParseHasMainTown = onParseHasMainTown
            self.onParseMainTown = onParseMainTown
        }
        
    }
    
}

public extension Map.Loader.Parser.Inspector.PlayersInfoInspector {
    typealias OnParseIsPlayableByHuman      = (Bool, PlayerColor) -> Void
    typealias OnParseIsPlayableByAI         = (Bool, PlayerColor) -> Void
    typealias OnParseAITactic               = (AITactic?, PlayerColor) -> Void
    typealias OnParsePlayableFactions       = ([Faction], PlayerColor) -> Void
    typealias OnParseHasMainTown            = (Bool, PlayerColor) -> Void
    typealias OnParseMainTown               = (Map.InformationAboutPlayers.PlayerInfo.MainTown?, PlayerColor) -> Void
    
    func didParseIsPlayableByHuman(_ value: Bool, playerColor: PlayerColor) {
        onParseIsPlayableByHuman?(value, playerColor)
    }
    func didParseIsPlayableByAI(_ value: Bool, playerColor: PlayerColor) {
        onParseIsPlayableByAI?(value, playerColor)
    }
    func didParseAITactic(_ value: AITactic?, playerColor: PlayerColor) {
        onParseAITactic?(value, playerColor)
    }
    func didParsePlayableFactions(_ value: [Faction], playerColor: PlayerColor) {
        onParsePlayableFactions?(value, playerColor)
    }
    func didParseHasMainTown(_ value: Bool, playerColor: PlayerColor) {
        onParseHasMainTown?(value, playerColor)
    }

    func didParseMainTown(_ value: Map.InformationAboutPlayers.PlayerInfo.MainTown?, playerColor: PlayerColor) {
        onParseMainTown?(value, playerColor)
    }
    
}
