//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

// MARK: Map Object
public extension Scenario.Map {
    
    /// An interactive or purely ornamental object on the adventure map. E.g. a
    /// `Town`, `Hero`, `Monster`, `Gold Mine` or a `tree` or `cursed grounds`.
    ///
    /// https://heroes.thelazy.net/index.php/Adventure_Map#List_of_adventure_map_objects
    ///
    enum Object: Model {
        
        /// An interactive object on the map, e.g. a `town`, `hero` or resources.
        case interactive(Interactive)
        
        /// Non-interactive object, but potentially effectful, e.g. `magic plains`
        /// or `cursed ground` or entirely effectless and purely ornamental like
        /// a `tree`
        case nonInteractive(NonInteractive)
    }
}

// MARK: - Query
// MARK: -
public extension Scenario.Map.Object {
    var interactive: Interactive? {
        guard case .interactive(let value) = self else { return nil }
        return value
    }

}
public extension Scenario.Map.Object.Interactive {
    var `mutable`: Scenario.Map.Object.Interactive.Mutable? {
        guard case .mutable(let value) = self else { return nil }
        return value
    }

    var immutable: Scenario.Map.Object.Interactive.Immutable? {
        guard case .immutable(let value) = self else { return nil }
        return value
    }
}


// MARK: Factory
// MARK: -
internal extension Scenario.Map.Object {
    
    static func mutable(_ mutable: Interactive.Mutable) -> Self {
        .interactive(.mutable(mutable))
    }
    
    static func immutable(_ immutable: Interactive.Immutable) -> Self {
        .interactive(.immutable(immutable))
    }
    
    static func flaggable(_ flaggable: Interactive.Mutable.Flaggable) -> Self {
        .mutable(.flaggable(flaggable))
    }
    
    static func perisable(_ perishable: Interactive.Mutable.Perishable) -> Self {
        .mutable(.perishable(perishable))
    }
    
    static func nonInteractive(magicalTerrain: NonInteractive.Effectful.MagicalTerrain) -> Self {
        .nonInteractive(.effectful(.magicalTerrain(magicalTerrain)))
    }
    
    static func nonInteractive(effectful: NonInteractive.Effectful) -> Self {
        .nonInteractive(.effectful(effectful))
    }
    
    static func nonInteractive(effectless: NonInteractive.Effectless) -> Self {
        .nonInteractive(.effectless(effectless))
    }
    
    static func conditionallyPerishable(
        _ conditionallyPerishable: Interactive.Mutable.Perishable.Conditional
    ) -> Self {
        .perisable(.conditional(conditionallyPerishable))
    }
    
    static func immediatelyPerishable(
        _ immediatelyPerishable: Interactive.Mutable.Perishable.Immediately
    ) -> Self {
        .perisable(.immediately(immediatelyPerishable))
    }
    
    static func visitable(_ visitable: Interactive.Mutable.Visitable) -> Self {
        .mutable(.visitable(visitable))
    }
    
    static func visitableOncePerHero(_ visitableOncePerHero: Interactive.Mutable.Visitable.OncePerHero) -> Self {
        .visitable(.oncePerHero(visitableOncePerHero))
    }
}
