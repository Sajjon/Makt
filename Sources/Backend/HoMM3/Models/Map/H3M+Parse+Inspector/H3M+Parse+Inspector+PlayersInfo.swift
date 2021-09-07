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
        private let onFinishParsingInformationAboutPlayers: OnFinishParsingInformationAboutPlayers?
        
        public init(
            onParseIsPlayableByHuman  : OnParseIsPlayableByHuman? = nil,
            onParseIsPlayableByAI: OnParseIsPlayableByAI? = nil,
            onParseAITactic: OnParseAITactic? = nil,
            onParsePlayableFactions: OnParsePlayableFactions? = nil,
            onParseHasMainTown: OnParseHasMainTown? = nil,
            onParseMainTown: OnParseMainTown? = nil,
            onFinishParsingInformationAboutPlayers: OnFinishParsingInformationAboutPlayers? = nil
        ) {
            self.onParseIsPlayableByHuman = onParseIsPlayableByHuman
            self.onParseIsPlayableByAI = onParseIsPlayableByAI
            self.onParseAITactic = onParseAITactic
            self.onParsePlayableFactions = onParsePlayableFactions
            self.onParseHasMainTown = onParseHasMainTown
            self.onParseMainTown = onParseMainTown
            self.onFinishParsingInformationAboutPlayers = onFinishParsingInformationAboutPlayers
        }
        
    }
    
}

public extension Map.Loader.Parser.Inspector.PlayersInfoInspector {
    typealias OnParseIsPlayableByHuman      = (Bool, Player) -> Void
    typealias OnParseIsPlayableByAI         = (Bool, Player) -> Void
    typealias OnParseAITactic               = (AITactic?, Player) -> Void
    typealias OnParsePlayableFactions       = ([Faction], Player) -> Void
    typealias OnParseHasMainTown            = (Bool, Player) -> Void
    typealias OnParseMainTown               = (Map.InformationAboutPlayers.PlayerInfo.MainTown?, Player) -> Void
    typealias OnFinishParsingInformationAboutPlayers   = (Map.InformationAboutPlayers) -> Void
    
    func didParseIsPlayableByHuman(_ value: Bool, player: Player) {
        onParseIsPlayableByHuman?(value, player)
    }
    func didParseIsPlayableByAI(_ value: Bool, player: Player) {
        onParseIsPlayableByAI?(value, player)
    }
    func didParseAITactic(_ value: AITactic?, player: Player) {
        onParseAITactic?(value, player)
    }
    func didParsePlayableFactions(_ value: [Faction], player: Player) {
        onParsePlayableFactions?(value, player)
    }
    func didParseHasMainTown(_ value: Bool, player: Player) {
        onParseHasMainTown?(value, player)
    }

    func didParseMainTown(_ value: Map.InformationAboutPlayers.PlayerInfo.MainTown?, player: Player) {
        onParseMainTown?(value, player)
    }
    
    func didFinishParsingInformationAboutPlayers(_ value: Map.InformationAboutPlayers) {
        onFinishParsingInformationAboutPlayers?(value)
    }
}
