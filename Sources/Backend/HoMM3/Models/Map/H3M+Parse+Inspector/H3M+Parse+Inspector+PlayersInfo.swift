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
        private let onParseBehaviour: OnParseBehaviour?
        private let onParseTownTypes: OnParseTownTypes?
        private let onParseHasMainTown: OnParseHasMainTown?
        private let onParseMainTown: OnParseMainTown?
        private let onFinishParsingInformationAboutPlayers: OnFinishParsingInformationAboutPlayers?
        
        public init(
            onParseIsPlayableByHuman  : OnParseIsPlayableByHuman? = nil,
            onParseIsPlayableByAI: OnParseIsPlayableByAI? = nil,
            onParseBehaviour: OnParseBehaviour? = nil,
            onParseTownTypes: OnParseTownTypes? = nil,
            onParseHasMainTown: OnParseHasMainTown? = nil,
            onParseMainTown: OnParseMainTown? = nil,
            onFinishParsingInformationAboutPlayers: OnFinishParsingInformationAboutPlayers? = nil
        ) {
            self.onParseIsPlayableByHuman = onParseIsPlayableByHuman
            self.onParseIsPlayableByAI = onParseIsPlayableByAI
            self.onParseBehaviour = onParseBehaviour
            self.onParseTownTypes = onParseTownTypes
            self.onParseHasMainTown = onParseHasMainTown
            self.onParseMainTown = onParseMainTown
            self.onFinishParsingInformationAboutPlayers = onFinishParsingInformationAboutPlayers
        }
        
    }
    
}

public extension Map.Loader.Parser.Inspector.PlayersInfoInspector {
    typealias OnParseIsPlayableByHuman      = (Bool, Player) -> Void
    typealias OnParseIsPlayableByAI         = (Bool, Player) -> Void
    typealias OnParseBehaviour               = (Behaviour?, Player) -> Void
    typealias OnParseTownTypes       = ([Faction], Player) -> Void
    typealias OnParseHasMainTown            = (Bool, Player) -> Void
    typealias OnParseMainTown               = (Map.InformationAboutPlayers.PlayerInfo.MainTown?, Player) -> Void
    typealias OnFinishParsingInformationAboutPlayers   = (Map.InformationAboutPlayers) -> Void
    
    func didParseIsPlayableByHuman(_ value: Bool, player: Player) {
        onParseIsPlayableByHuman?(value, player)
    }
    func didParseIsPlayableByAI(_ value: Bool, player: Player) {
        onParseIsPlayableByAI?(value, player)
    }
    func didParseBehaviour(_ value: Behaviour?, player: Player) {
        onParseBehaviour?(value, player)
    }
    func didParseTownTypes(_ value: [Faction], player: Player) {
        onParseTownTypes?(value, player)
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
