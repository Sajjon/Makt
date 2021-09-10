//
//  H3M+Parse+Inspector.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-29.
//

import Foundation
import Malm

public extension Map.Loader.Parser {
    final class Inspector {
        
        internal let basicInfoInspector: BasicInfoInspector?
        internal let playersInfoInspector: PlayersInfoInspector?
        internal let additionalInformationInspector: AdditionalInfoInspector?
        
        private let onParseWorld: OnParseWorld?
        private let onParseAttributesOfObjects: OnParseAttributesOfObjects?
        private let willParseObject: WillParseObject?
        private let onParseObject: OnParseObject?
        private let onParseAllObjects: OnParseAllObjects?
        private let onParseEvents: OnParseEvents?
        
        public let settings: Settings
        
        init(
            settings: Settings = .init(),
            basicInfoInspector: BasicInfoInspector? = nil,
            playersInfoInspector: PlayersInfoInspector? = nil,
            additionalInformationInspector: AdditionalInfoInspector? = nil,
            onParseWorld: OnParseWorld? = nil,
            onParseAttributesOfObjects: OnParseAttributesOfObjects? = nil,
            willParseObject: WillParseObject? = nil,
            onParseObject: OnParseObject? = nil,
            onParseAllObjects: OnParseAllObjects? = nil,
            onParseEvents: OnParseEvents? = nil
        ) {
            self.settings = settings
            
            self.basicInfoInspector = basicInfoInspector
            
            self.playersInfoInspector = playersInfoInspector
            self.additionalInformationInspector = additionalInformationInspector
            
            self.onParseWorld = onParseWorld
            self.onParseAttributesOfObjects = onParseAttributesOfObjects
            self.willParseObject = willParseObject
            self.onParseObject = onParseObject
            self.onParseAllObjects = onParseAllObjects
            self.onParseEvents = onParseEvents
        }
    }
}

public extension Map.Loader.Parser.Inspector {
    
    struct Settings {
        public let maxObjectsToParse: Int?
        public init(maxObjectsToParse: Int? = nil) {
            self.maxObjectsToParse = maxObjectsToParse
        }
    }
    
    typealias OnParseBasicInfo = (Map.BasicInformation) -> Void
    typealias OnParseWorld = (Map.World) -> Void
    typealias OnParseAttributesOfObjects = (Map.AttributesOfObjects) -> Void
    typealias WillParseObject = (Position, Map.Object.Attributes) -> Void
    typealias OnParseObject = (Map.Object) -> Void
    typealias OnParseAllObjects = (Map.DetailsAboutObjects) -> Void
    typealias OnParseEvents = (Map.TimedEvents) -> Void
    
    
    func didParseWorld(_ world: Map.World) {
        onParseWorld?(world)
    }
    
    func didParseAttributesOfObjects(_ attributesOfObjects: Map.AttributesOfObjects) {
        onParseAttributesOfObjects?(attributesOfObjects)
    }
    
    
    func willParseObject(at position: Position, attributes: Map.Object.Attributes) {
        willParseObject?(position, attributes)
    }
    
    func didParseObject(_ object: Map.Object) {
        onParseObject?(object)
    }
    
    func didParseAllObjects(_ objects: Map.DetailsAboutObjects) {
        onParseAllObjects?(objects)
    }
    
    func didParseEvents(_ events: Map.TimedEvents) {
        onParseEvents?(events)
    }
}
