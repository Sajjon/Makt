//
//  Map+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    
    /// A global event that occurs at a certain time.
    /// Not to be confused with geo event, that is trigger when a player walks on a certain tile with a hero.
    struct TimedEvent: Hashable, CustomDebugStringConvertible, Codable {
        
        public struct Occurrences: Hashable, Codable {
            public enum Subsequent: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible, Codable {
                public static let neverRawValue = 0
                public static let never: Self? = nil
                case everyDay = 1
                case everyTwoDays = 2
                case everyThreeDays = 3
                case everyFourDays = 4
                case everyFiveDays = 5
                case everySixDays = 6
                case everySevenDays = 7
                case every14Days = 14
                case every21Days = 21
                case every28Days = 28
                
                public var debugDescription: String {
                    switch self {
                    case .everyDay: return "everyDay"
                    case .everyTwoDays: return "everyTwoDays"
                    case .everyThreeDays: return "everyThreeDays"
                    case .everyFourDays: return "everyFourDays"
                    case .everyFiveDays: return "everyFiveDays"
                    case .everySixDays: return "everySixDays"
                    case .everySevenDays: return "everySevenDays"
                    case .every14Days: return "every14Days"
                    case .every21Days: return "every21Days"
                    case .every28Days: return "every28Days"
                    }
                }
            }
            
            public let first: UInt16
            public let subsequent: Subsequent?
            public init(first: UInt16, subsequent: Subsequent? = nil) {
                self.first = first
                self.subsequent = subsequent
            }
        }
        
        public let name: String?
        public let message: String?
        
        /// Resources to be gained OR taken
        public let resources: Resources?
        
        public let occurrences: Occurrences
        public let availability: Availability
        
        public init(
            name: String? = nil,
            message: String? = nil,

            firstOccurence: UInt16,
            subsequentOccurence: Occurrences.Subsequent? = nil,
            
            affectedPlayers: [Player],
            appliesToHumanPlayers: Bool = true,
            appliesToComputerPlayers: Bool = false,
            resources: Resources? = nil
        ) {
            self.name = name
            self.occurrences = .init(first: firstOccurence, subsequent: subsequentOccurence)
        
            self.message = message
            self.resources = resources
            
            self.availability = .init(
                affectedPlayers: affectedPlayers,
                appliesToHumanPlayers: appliesToHumanPlayers,
                appliesToComputerPlayers: appliesToComputerPlayers
            )
        }
        
        // MARK: Availability
        public struct Availability: Hashable, CustomDebugStringConvertible, Codable {
            
            /// MapEditor: "Players to which event applies"
            public let affectedPlayers: [Player]
            
            /// MapEditor: "Apply event to computer players"
            public let appliesToHumanPlayers: Bool
            
            /// MapEditor: "Apply event to computer players"
            public let appliesToComputerPlayers: Bool
            
            public init(
                affectedPlayers: [Player],
                appliesToHumanPlayers: Bool,
                appliesToComputerPlayers: Bool
            ) {
                self.affectedPlayers = affectedPlayers
                self.appliesToHumanPlayers = appliesToHumanPlayers
                self.appliesToComputerPlayers = appliesToComputerPlayers
            }
            
            public var debugDescription: String {
                """
                affectedPlayers: \(affectedPlayers)
                appliesToHumanPlayers: \(appliesToHumanPlayers)
                appliesToComputerPlayers: \(appliesToComputerPlayers)
                """
            }
        }
        
        public var debugDescription: String {
            let optionalStrings: [String?] = [
                "occurrences: \(occurrences)",
                "availability: \(availability)",
                name.map { "name: \($0)" } ,
                message.map { "message: \($0)" } ,
                resources.map { "resources: \($0)" } ,
            ]
            
            return optionalStrings.filterNils().joined(separator: "\n")
        }
    }
    
}
